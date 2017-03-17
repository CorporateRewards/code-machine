class CodeSubmission < ApplicationRecord
	# belongs_to :mr_user
    validate :code_must_be_valid

    def code_must_be_valid
    if !Code.where("code = ?",self.code).blank?
    	true
    else
      errors.add(:code, "is not valid")
      false
    end
	end

end
