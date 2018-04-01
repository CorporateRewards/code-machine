class Code < ApplicationRecord
  # belongs_to :programme
  require 'kaminari'
  has_one :code_submission
  paginates_per 10
  validates_uniqueness_of :code
  # validates :code, uniqueness: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # Generate a code for the enquiry
      generate_code(row)

      # Check to see which user (if any) qualifies for the tickets
      calculate_booking_user(row)

      # Now check to see if the qualifying user is registered
      check_if_user_registered(row)

      # Calculate how many tickets the enquiry is worth based on the users user group
      find_group_and_assign_tickets(row)

      # Check if it's actually a qualifying booking (ticket calc still valid incase manually decide to approve the enquiry)
      calculate_qualifying_booking(row)

      # Check to see if there are other enquiries for the same date for the booking user
      requires_approval?(row)

      # Check if valid and create the enquiry code
      code = Code.new(row.to_hash)
      until code.valid? do
        generate_code(row)
        code = Code.new(row.to_hash)
      end
      
      code.save

      # Send the code to the user
      send_claim_code_to_user(row)
    end
    # Now delete the users file if it exists
    File.delete('registered-users.csv') if File::exists?('registered-users.csv')
  end

  def self.update(file)
    CSV.foreach(file.path, headers: true) do |row|
      code = Code.find(row["id"])
      code.update(row.to_hash)
      code.save!
    end
  end


  # Create an individual code and apply all checks
  def self.new_code(create_code)
      row = create_code
      generate_code(row)
      calculate_booking_user(row)
      check_if_user_registered(row)
      find_group_and_assign_tickets(row)
      calculate_qualifying_booking(row)
      requires_approval?(row)
      
      # Check if valid and create the enquiry code
      code = Code.new(row.to_hash)
      until code.valid? do
        generate_code(row)
        code = Code.new(row.to_hash)
      end

      code.save

      send_claim_code_to_user(row)
      # Now delete the users file if it exists
      File.delete('registered-users.csv') if File::exists?('registered-users.csv')

  end



  def self.calculate_booking_user(row)
    if row["agency_email"].nil? && row["booking_email"].nil?
      puts "no user provided"
      false
    else
      row["booking_user_email"] = row["agency_email"].present? ? row["agency_email"].downcase : row["booking_email"].downcase
    end
  end

  def self.check_if_user_registered(row)
    user = MrUser.find_by(email: row["booking_user_email"])
    if user
      row["user_registered_at"] = user.created_at
    else 
      s3 = Aws::S3::Client.new
      File.open('registered-users.csv', 'wb') do |file|
        resp = s3.get_object({ bucket: 'code-machine', key:'users.csv' }, target: file)
      end
      csv_content = File.read('registered-users.csv')
      csv = CSV.parse(csv_content, :headers => true)
      csv.each do |line|
        row['user_registered_at'] = csv.find {|line| line["email"] == row["booking_user_email"]} ?  DateTime.current : nil
        row['user_group'] = csv.find {|line| line["email"] == row["booking_user_email"]} ?  line["user group"] : "not registered"
      end
    end
  end

  def self.find_group_and_assign_tickets(row)
    user = MrUser.find_by(email: row["booking_user_email"])
    row["user_group"] = user ? user.user_group.downcase : row["user_group"]
    # row["user_group"] = user_group
    if row["user_group"] == "employees1" || row["user_group"] == "direct users"
      row["number_of_tickets"] = 2
    elsif row["user_group"] == "agency users" || row["user_group"] == "agency override users"
      row["number_of_tickets"] = 1
    else
      row["number_of_tickets"] = 0
    end
  end

  def self.generate_code(row) 
    claim_code = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join
    row["code"] = claim_code + row["reference"]
  end

  def self.send_claim_code_to_user(row)
    if row["approval_required_at"].nil? and !row["booking_user_email"].nil?
      puts "email sent"
      puts row["booking_user_email"]
      puts row["code"]
    else
      puts "unable to send code"
    end
  end

  def self.calculate_qualifying_booking(row)

    approval_types = ['COG Corporate Group','xmas']

    qualifying_types = [
                        'DMC',
                        'GCRP',
                        'BAN Association',
                        'ANNE',
                        'ASCE',
                        'AUCT',
                        'BANC',
                        'DAYM',
                        'EXHB',
                        'RESC',
                        'RTRG',
                        'TEAM',
                        'TRNG',
                        'BAN Christmas Company',
                        'BAN Company',
                        'CDR Assessment Centre',
                        'CDR Associations',
                        'CDR Company Communication',
                        'CDR Company Training',
                        'CDR Executive Meeting',
                        'CDR Networking',
                        'CDR Product Launch',
                        'CDR Public Training',
                        'CDR Roadshow / Series',
                        'CDR Team Building',
                        'COG Incentives',
                        'CON Pre Agreed Contract',
                        'CON Residential Training',
                        'EXH Exhibition'
                      ]

    if qualifying_types.map(&:downcase).include?(row["booking_type"].downcase)
      row["qualifying_booking_type"] = true
    elsif approval_types.map(&:downcase).include?(row["booking_type"].downcase)
      row["approval_required_at"] = DateTime.current
      row["qualifying_booking_type"] = true
    else
      row["qualifying_booking_type"] = false
    end
  end

  def self.requires_approval?(row)
    similar_bookings = Code.where(booking_user_email: row["booking_user_email"], arrival_date: row["arrival_date"])
    if similar_bookings.length > 0
      row["approval_required_at"] = DateTime.current
    end
  end

  def similar_bookings
    code = Code.find(self[:id])
    bookings = Code.where(booking_user_email: code.booking_user_email, arrival_date: code.arrival_date).where.not(id: code.id)
  end

  def approve_code
    code = Code.find(self[:id])
    code.update(approved_at: DateTime.current)
  end

  def process_code
    code = Code.find(self[:id])
    code.update(date_sent: DateTime.current)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |code|
        csv << code.attributes.values_at(*column_names)
      end
    end
  end


end
