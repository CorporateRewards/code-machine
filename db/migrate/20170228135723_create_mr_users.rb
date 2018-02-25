class CreateMrUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :mr_users do |t|
      t.integer :cr_id
  		t.string :name
  		t.string :email
  		t.string :user_group
  		t.string :company
  		t.string :country
      t.timestamps
    end
  end
end
