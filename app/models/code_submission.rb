class CodeSubmission < ApplicationRecord
	  # belongs_to :mr_user
   # belongs_to :code

    validate :code_must_be_valid
    validate :correct_user, :if => :code_must_be_valid

    cattr_accessor :current_user

    def code_must_be_valid
      if !Code.where("code = ?",self.code).blank?
      	true
      else
        errors.add(:code, "is not valid")
        false
      end
    end


    def correct_user
      @code = Code.find_by code: self.code
      @code_email = @code.booking_user_email.to_s

      if CodeSubmission.current_user.email == @code_email
        true
      else
        errors.add(:Sorry, "#{CodeSubmission.current_user.email} it looks like this code wasn't for you, it was sent to #{@code_email}")
        false
      end
    end
end