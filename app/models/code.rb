class Code < ApplicationRecord
  # belongs_to :programme
  has_one :code_submission


  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      calculate_booking_user(row)
      find_group_and_assign_tickets(row)
      Code.create! row.to_hash
    end
  end

  def self.calculate_booking_user(row)
    if row["agency_email"].nil? && row["booking_email"].nil?
      puts "no user provided"
    else
      row["booking_user_email"] = row["agency_email"].present? ? row["agency_email"] : row["booking_email"]
    end
  end

  def self.find_group_and_assign_tickets(row)
    user = MrUser.find_by(email: row["booking_user_email"])
    user_group = user ? user.user_group : "none"
    row["number_of_tickets"] = (user_group == "Employees1") ? 2 : 1
    row["user_group"] = user_group
  end



end
