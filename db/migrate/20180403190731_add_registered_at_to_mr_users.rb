class AddRegisteredAtToMrUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :mr_users, :registered_at, :datetime
  end
end
