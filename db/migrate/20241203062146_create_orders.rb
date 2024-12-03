class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :customer_user, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end
