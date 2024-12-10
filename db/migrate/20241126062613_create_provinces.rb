# frozen_string_literal: true

class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :provinces, :name, unique: true
  end
end
