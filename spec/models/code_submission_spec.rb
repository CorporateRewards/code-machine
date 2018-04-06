require 'rails_helper'

RSpec.describe CodeSubmission do
  describe 'validations' do
    it { should validate_presence_of(:code_entered) }
    it { is_expected.to belong_to(:mr_user) }
    it { is_expected.to belong_to(:code) }
  end

  it "should ensure only the user who was sent the code can claim the code" do
    user = MrUser.new("Gill", "gillian@corporaterewards.co.uk")
  end

  it "should ensure the code is valid and unclaimed"

  end
end 