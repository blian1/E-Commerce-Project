# frozen_string_literal: true

ActiveAdmin.register Order do
  permit_params :status

  index do
    selectable_column
    id_column
    column 'Customer Name' do |order|
      order.customer_user.name
    end
    column :total_price
    column :status
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Order Details' do
      f.input :status, as: :select, collection: %w[unpaid paid shipped completed canceled]
    end
    f.actions
  end

  show do
    attributes_table do
      row 'Order ID', &:id
      row 'Date' do |order|
        order.created_at.strftime('%B %d, %Y %H:%M')
      end
    end

    panel 'Order Items' do
      table_for order.order_items do
        column 'Product' do |item|
          link_to item.product.name, admin_product_path(item.product) if item.product.present?
        end
        column 'Quantity', &:quantity
        column 'Price' do |item|
          "$#{item.price}"
        end
        column 'Total' do |item|
          "$#{(item.price * item.quantity).round(2)}"
        end
      end
    end

    panel 'Taxes' do
      attributes_table_for order do
        row('GST') { |order| "(#{(order.customer_user.province.gst * 100).round(1)}%) $#{order.gst}" }
        row('PST') { |order| "(#{(order.customer_user.province.pst * 100).round(1)}%) $#{order.pst}" }
        row('HST') { |order| "(#{(order.customer_user.province.hst * 100).round(1)}%) $#{order.hst}" }
      end
    end

    panel 'Order Summary' do
      attributes_table_for order do
        row('Subtotal') { |order| "$#{order.subtotal}" }
        row('Total Taxes') { |order| "$#{(order.gst + order.pst + order.hst).round(2)}" }
        row('Total Price') { |order| "$#{order.total_price}" }
        row('Address') { |order| order.customer_user.address }
        row('Phone') { |order| order.customer_user.phone_number }
        row('Status', &:status)
        row('Paypal', &:paypal_order_id)
      end
    end
  end

  filter :status, as: :select, collection: %w[pending paid shipped completed canceled]
  filter :created_at
  filter :total_price
end
