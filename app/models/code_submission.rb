class CodeSubmission < ApplicationRecord
	  # belongs_to :mr_user

    # validate :code_must_be_valid
    validate :correct_user, :code_not_claimed, :if => :code_must_be_valid

    cattr_accessor :current_user

    def code2
      @code = Code.find_by code: self.code
    end

    def code_must_be_valid
      if !code2.blank?
      	true
      else
        errors.add(:code, "is not valid")
        false
      end
    end


    def correct_user

      @code_email = code2.booking_user_email.to_s

      if CodeSubmission.current_user.email == @code_email
        true
      else
        errors.add(:Sorry, "#{CodeSubmission.current_user.email} it looks like this code wasn't for you, it was sent to #{@code_email}")
        false
      end
    end

    def code_not_claimed
      # @code = Code.find_by code: self.code
      if code2.date_claimed.blank?
        true
      else
        errors.add(:code, "has already been claimed")
        false
      end
    end
end