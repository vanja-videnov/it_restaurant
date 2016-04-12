class CreateOrderMenuItems < ActiveRecord::Migration
  def change
    create_table :order_menu_items do |t|
      t.integer :quantity, default: 0
      t.string :details
      t.references :order, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
