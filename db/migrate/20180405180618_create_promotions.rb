class CreatePromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.datetime :valid_from
      t.datetime :valid_to
      t.string :promotion_detail
      t.timestamps
    end
  end
end
