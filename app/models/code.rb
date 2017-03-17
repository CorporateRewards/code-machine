class Code < ApplicationRecord
  # belongs_to :programme
  has_one :code_submission
end
