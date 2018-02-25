class ChangeCodeToCodeEnteredInCodeSubmissions < ActiveRecord::Migration[5.0]
  def change
    rename_column :code_submissions, :code, :code_entered
  end
end
