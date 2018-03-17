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

  def self.calculate_booking_user(row)
    if row["agency_email"].nil? && row["booking_email"].nil?
      puts "no user provided"
      false
    else
      row["booking_user_email"] = row["agency_email"].present? ? row["agency_email"] : row["booking_email"]
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
    row["code"] = row["reference"] + claim_code
  end

  def self.send_claim_code_to_user(row)
    puts "email sent"
    puts row["booking_user_email"]
    puts row["code"]
  end

  def self.calculate_qualifying_booking(row)
    unqualifying_types = ['grp', 'xmas', 'glfb']
    if unqualifying_types.include?(row["booking_type"].downcase)
      row["qualifying_booking_type"] = false
      row["number_of_tickets"] = 0
    else
      row["qualifying_booking_type"] = true
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

end
