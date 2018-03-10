require 'csv'

namespace :import do

  desc "Import codes from csv"
  task codes: :environment do
    filename = File.join Rails.root, "codes.csv"
    #filename = params[:file]
    CSV.foreach(filename, headers: true) do |row|
      puts "start row"
      Code.calculate_booking_user(row) ? true : next
      puts row["booking_email"]
      puts row["agency_email"]
      puts row["booking_user_email"]
      Code.find_group_and_assign_tickets(row)
      puts row["user_group"]
      puts row["number_of_tickets"]
      Code.send_claim_code_to_user(row)
    end  
  end 


end