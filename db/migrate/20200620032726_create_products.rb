class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false, index: true
      t.text :text, null: false
      t.integer :price, null: false, index: true
      t.string :brand, index: true
      t.references :category, null: false, foreign_key: true
      t.references :size, foreign_key: true
      t.references :status, foreign_key: true
      t.references :postage, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      t.references :shipping_date, null: false, foreign_key: true
      t.boolean :purchase, null: false, default: false
      t.timestamps
    end
  end
end
