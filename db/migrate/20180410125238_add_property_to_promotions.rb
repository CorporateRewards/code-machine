class AddPropertyToPromotions < ActiveRecord::Migration[5.0]
  def change
    add_column :promotions, :property, :string
  end
end
