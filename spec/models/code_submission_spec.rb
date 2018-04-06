require 'rails_helper'

RSpec.describe CodeSubmission do
  describe 'validations' do
    it { should validate_presence_of(:code_entered) }
    it { is_expected.to belong_to(:mr_user) }
    it { is_expected.to belong_to(:code) }
  end

  it "should only allow the booking user to claim the code" do

  end
end 