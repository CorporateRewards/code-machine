class CreateCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :codes do |t|
      t.string :code
      t.string :property
  	  t.string :reference
  	  t.string :post_as
  	  t.string :arrival_date
  	  t.string :status
  	  t.string :booking_type
  	  t.string :booked_date
  	  t.string :booking_user_email
  	  t.string :number_of_tickets
  	  t.string :user_group
  	  t.datetime :date_claimed
  	  t.datetime :date_sent
      t.timestamps
    end
  end
end
