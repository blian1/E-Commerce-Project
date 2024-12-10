# frozen_string_literal: true

class AddProvinceToCustomerUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :customer_users, :province, null: true, foreign_key: true
  end
end
