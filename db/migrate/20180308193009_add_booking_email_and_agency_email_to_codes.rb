class AddBookingEmailAndAgencyEmailToCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :booking_email, :string
    add_column :codes, :agency_email, :string 
  end
end
