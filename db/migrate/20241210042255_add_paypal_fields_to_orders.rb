# frozen_string_literal: true

class AddPaypalFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :paypal_order_id, :string
    add_column :orders, :paypal_payment_id, :string
  end
end
