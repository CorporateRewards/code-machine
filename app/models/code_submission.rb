class CodeSubmission < ApplicationRecord
  # belongs_to :mr_user
  belongs_to :code
  belongs_to :mr_user
  validates :code_entered, :presence => true
  validate :correct_user, :if => :valid_and_unclaimed

  cattr_accessor :current_user


  def code_submitted
    @code_entered = Code.find_by(code: self.code_entered)
  end


  def valid_and_unclaimed
    if code_submitted.blank?
      errors.add(:code_entered, "is not valid, please only enter the claim code you received from us")
      false
    elsif claimed?
      errors.add(:code_entered, "has already been claimed")
      false
    else
      true
    end
  end


  def claimed?
    code_submitted.date_claimed.present?
  end


  def correct_user
    @code_email = Code.find_by(code: self.code_entered).booking_user_email.to_s unless code_submitted.blank?

    if current_user.email == @code_email
      true
    else
      errors.add(:Sorry, "#{CodeSubmission.current_user.email} it looks like this code wasn't for you, it was sent to #{@code_email}")
      false
    end
  end

end