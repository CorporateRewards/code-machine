class AddMruserToCodeSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_index :code_submissions, :user_id
  end
end
