class AddUserRegisteredAtToCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :user_registered_at, :datetime
  end
end
