class Code < ApplicationRecord
  # belongs_to :programme
  require 'kaminari'
  has_one :code_submission
  paginates_per 10

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      generate_code(row)
      calculate_booking_user(row)
      find_group_and_assign_tickets(row)
      calculate_qualifying_booking(row)
      requires_approval?(row)
      Code.create! row.to_hash
      send_claim_code_to_user(row)
    end
  end

  def self.update(file)
    CSV.foreach(file.path, headers: true) do |row|
      code = Code.find(row["id"])
      code.update(row.to_hash)
      code.save!
    end
  end

  def self.new_code(create_code)
      row = create_code
      generate_code(row)
      calculate_booking_user(row)
      find_group_and_assign_tickets(row)
      calculate_qualifying_booking(row)
      requires_approval?(row)
      Code.create! row
      send_claim_code_to_user(row)
  end

  def self.calculate_booking_user(row)
    if row["agency_email"].nil? && row["booking_email"].nil?
      puts "no user provided"
      false
    else
      row["booking_user_email"] = row["agency_email"].present? ? row["agency_email"].downcase : row["booking_email"].downcase
    end
  end

  def self.find_group_and_assign_tickets(row)
    user = MrUser.find_by(email: row["booking_user_email"])
    user_group = user ? user.user_group.downcase : "not registered"
    row["user_group"] = user_group
    if user_group == "employees1" || user_group == "direct users"
      row["number_of_tickets"] = 2
    elsif user_group == "agency users"
      row["number_of_tickets"] = 2
    else
      row["number_of_tickets"] = 0
    end
  end

  def self.generate_code(row) 
    claim_code = SecureRandom.hex(6)
    row["code"] = claim_code + row["reference"]
  end

  def self.send_claim_code_to_user(row)
    if row["approval_required_at"].nil?
      puts "email sent"
      puts row["booking_user_email"]
      puts row["code"]
    end
  end

  def self.check_if_user_registered(row)
      api_key = ENV["api_key"]
      api_secret = ENV["api_secret"]
      @baseuser = Base64.strict_encode64("#{api_key}:#{api_secret}")
      @urlstring_to_post = "https://accounts.spotify.com/api/token"
      @result = HTTParty.post(@urlstring_to_post.to_str, 
        :body => { 
               },
        :headers => { 'Authorization' => 'Token token=#{@baseuser}' })
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
    bookings = Code.where(booking_user_email: code.booking_user_email, arrival_date: code.arrival_date)
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
