class CheckForNewRegistrationsJob < ActiveJob::Base

  def perform
    # Open connection to S3 and read in users.csv
    s3 = Aws::S3::Client.new
    
    File.open('registered-users.csv', 'wb') do |file|
      resp = s3.get_object({ bucket: 'code-machine', key:'users.csv' }, target: file)
    end

    csv_content = File.read('registered-users.csv')
    csv = CSV.parse(csv_content, :headers => true)
    unregistered_codes = Code.where(user_registered_at: [nil, ""])
    unregistered_codes.each do |code|
      puts code.booking_user_email
      puts code.id
      
      # Check for the booking user email in the users file
      csv.each do |line|
        if line["email"].downcase == code.booking_user_email.downcase
          code.user_registered_at = line["date registered"].to_date
          if line["date registered"] and (line["date registered"].to_date < (code.created_at + 4.weeks))
            code.user_group = line["user group"]
            code.approved_by = "registered in time"
            code.save
          elsif line["date registered"] and (line["date registered"].to_date > (code.created_at + 4.weeks))
            code.user_group = line["user group"]    
            code.approved_by = "registered too late"
            code.save
          end
        end
      end
    end
  end
end
