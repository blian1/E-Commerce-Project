# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.string :category

      t.timestamps
    end
  end
end
