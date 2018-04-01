require 'rails_helper'

RSpec.describe Code, type: :model do
  it { should validate_uniqueness_of(:code) }
end