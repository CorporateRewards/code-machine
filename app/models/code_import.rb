class CodeImport < ApplicationRecord

include ActiveModel::Model
  def persisted?
    false
  end

  def valid_file?(file)
    CSV.foreach(file.path, headers: true) do |row|
      code = Code.new(row.to_hash)
      if code.valid?
        true
      else
        errors.add :base, "Row: #{code.errors.full_messages}"
        return false
      end
    end
  end

  def self.validate_file(file)
    @error_rows = []
    CSV.foreach(file.path, headers: true) do |row|
      @data = Code.new(row.to_hash)
      if !@data.valid?
        @error_rows.push(@data.errors.full_messages)
      end
    end
    if @error_rows.length == 0
      puts "file invalid"
      return @error_rows
    else
      puts "file valid"
      # return true
    end
    # @data.errors.add(@error_rows)
  end

  def self.codes_in_file(file)
    codes = CSV.read(file.path, headers: true).map { |row| Code.new(row.to_hash) }
    if codes.map(&:valid?).all?
      codes_in_file.each(&save!)
    else
      codes_in_file.each_with_index do |code, index|
        code.errors.full_messages.each do |msg|
          errors.add :base, "Row #{index+2}: #{msg}"
        end
      end
    end
  end

  def self.import(file)
    codes_in_file.each do |row|
      code = Code.new(row.to_hash)
      code.initiate_code

      # Check if valid and create the enquiry code
      code.save

      # Send the code to the user
      code.send_claim_code_to_user
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



  end