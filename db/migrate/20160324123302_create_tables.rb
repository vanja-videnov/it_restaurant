class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :number
      t.integer :sum, default: 0
      t.boolean :payment, default: true

      t.timestamps null: false
    end
  end
end
