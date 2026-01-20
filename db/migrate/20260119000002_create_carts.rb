class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.integer :status, default: 0, null: false
      t.decimal :total_price, precision: 10, scale: 2, default: 0.0
      t.datetime :last_interaction_at

      t.timestamps
    end

    add_index :carts, :status
    add_index :carts, :last_interaction_at
  end
end
