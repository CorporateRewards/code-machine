class Code < ApplicationRecord
  # belongs_to :programme
  require 'kaminari'
  has_one :code_submission
  paginates_per 10
  # validates_uniqueness_of :code, unless: :validate_file
  validates_presence_of :property, :reference, :post_as, :arrival_date, :status, :booking_type, :booked_date

  # def self.validate_file(file)
  #   @error_rows = []
  #   CSV.foreach(file.path, headers: true) do |row|
  #     @data = Code.new(row.to_hash)
  #     if !@data.valid?
  #       @error_rows.push(@data.errors.full_messages)
  #     end
  #   end
  #   if @error_rows.length == 0
  #     puts "file invalid"
  #     return @error_rows
  #   else
  #     puts "file valid"
  #     # return true
  #   end
  #   # @data.errors.add(@error_rows)
  # end

  # def self.codes_in_file(file)
  #   codes = CSV.read(file.path, headers: true).map { |row| Code.new(row.to_hash) }
  #   if codes.map(&:valid?).all?
  #     codes_in_file.each(&save!)
  #   else
  #     codes_in_file.each_with_index do |code, index|
  #       code.errors.full_messages.each do |msg|
  #         errors.add :base, "Row #{index+2}: #{msg}"
  #       end
  #     end
  #   end
  # end

  # def self.import(file)
  #   codes_in_file.each do |row|
  #     code = Code.new(row.to_hash)
  #     code.initiate_code

  #     # Check if valid and create the enquiry code
  #     code.save

  #     # Send the code to the user
  #     code.send_claim_code_to_user
  #   end
  #   # Now delete the users file if it exists
  #   File.delete('registered-users.csv') if File::exists?('registered-users.csv')
  # end


  # def self.update(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     code = Code.find(row["id"])
  #     code.update(row.to_hash)
  #     code.save!
  #   end
  # end


  def initiate_code
    generate_code
    calculate_booking_user
    check_if_user_registered
    calculate_qualifying_booking
    find_group_and_assign_tickets
    requires_approval?
    File.delete('registered-users.csv') if File::exists?('registered-users.csv')
  end

  def generate_code
    claim_code = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join + self.reference
    while Code.find_by(code: claim_code)
      generate_code(row)
    end
    self.code = claim_code
  end

  def calculate_booking_user
    if self.agency_email.nil? && self.booking_email.nil?
      puts "no user provided"
      false
    else
      self.booking_user_email = self.agency_email.present? ? self.agency_email.downcase : self.booking_email.downcase
    end
  end

  def check_if_user_registered
    user = MrUser.find_by(email: self.booking_user_email)
    if user
      self.user_registered_at = user.created_at
    else 
      s3 = Aws::S3::Client.new
      File.open('registered-users.csv', 'wb') do |file|
        resp = s3.get_object({ bucket: 'code-machine', key:'users.csv' }, target: file)
      end
      csv_content = File.read('registered-users.csv')
      csv = CSV.parse(csv_content, :headers => true)
      csv.each do |line|
        self.user_registered_at = csv.find {|line| line["email"] == self.booking_user_email} ?  DateTime.current : nil
        self.user_group = csv.find {|line| line["email"] == self.booking_user_email} ?  line["user group"] : "not registered"
      end
    end
  end

  def find_group_and_assign_tickets
    user = MrUser.find_by(email: self.booking_user_email)
    self.user_group = user ? user.user_group.downcase : self.user_group
    
    if self.user_group == "direct users"
      self.number_of_tickets = 2
    elsif self.user_group == "agency users" || self.user_group == "agency override users"
      self.number_of_tickets = 1
    else
      self.number_of_tickets = 0
    end

    if check_for_promotions
      if @promotions.promotion_detail == "double"
        qty = self.number_of_tickets.to_i
        qty *= 2
        self.number_of_tickets = qty
      else
        self.number_of_tickets
      end
    end   
  end

  def check_for_promotions 
    @promotions = Promotion.where(property: self.property).where("? BETWEEN valid_from and valid_to", Date.parse(self.booked_date)).first
  end

  def requires_approval?
    similar_bookings = Code.where(booking_user_email: self.booking_user_email, arrival_date: self.arrival_date)
    if similar_bookings.length > 0
      self.approval_required_at = DateTime.current
    end
  end

  def send_claim_code_to_user
    if self.approval_required_at.nil? and !self.booking_user_email.nil?
      puts "email sent"
      puts self.booking_user_email
      puts self.code
    else
      puts "unable to send code"
    end
  end

  def calculate_qualifying_booking

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

    if qualifying_types.map(&:downcase).include?(self.booking_type.downcase)
      self.qualifying_booking_type = true
    elsif approval_types.map(&:downcase).include?(self.booking_type.downcase)
      self.approval_required_at = DateTime.current
      self.qualifying_booking_type = true
    else
      self.qualifying_booking_type = false
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
