class AddCodeToCodeSubmission < ActiveRecord::Migration[5.0]
  def change
    add_reference :code_submissions, :code, foreign_key: true
  end
end
