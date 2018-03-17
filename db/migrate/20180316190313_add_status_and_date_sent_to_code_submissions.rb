class AddStatusAndDateSentToCodeSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :code_submissions, :status, :string
    add_column :code_submissions, :processed_at, :datetime
  end
end
