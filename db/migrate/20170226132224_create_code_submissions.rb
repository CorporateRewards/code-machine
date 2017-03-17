class CreateCodeSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :code_submissions do |t|
      t.string :code
      t.integer :user_id	
      t.string :user_email
      
      t.timestamps
    end
  end
end
