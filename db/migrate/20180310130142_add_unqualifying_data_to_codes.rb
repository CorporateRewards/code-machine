class AddUnqualifyingDataToCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :approval_required_at, :datetime
    add_column :codes, :approved_at, :datetime
    add_column :codes, :approved_by, :string
    add_column :codes, :qualifying_booking_type, :boolean 
  end
end
