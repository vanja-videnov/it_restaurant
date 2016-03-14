class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :manager, default: false
      t.string :email, :null => false
      t.string :password, :null => false
      t.string :name
      t.string :telephone

      t.timestamps null: false
    end
  end
end
