class Code < ApplicationRecord
  # belongs_to :programme
  #has_one :code_submission


  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Code.create! row.to_hash
    end
  end


end
