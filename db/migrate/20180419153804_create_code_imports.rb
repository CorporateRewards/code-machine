class CreateCodeImports < ActiveRecord::Migration[5.0]
  def change
    create_table :code_imports do |t|
      t.string :name
      t.timestamps
    end
  end
end
