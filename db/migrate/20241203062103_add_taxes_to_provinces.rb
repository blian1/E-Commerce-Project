class AddTaxesToProvinces < ActiveRecord::Migration[7.2]
  def change
    add_column :provinces, :pst, :decimal, precision: 5, scale: 3, default: 0.0, null: false
    add_column :provinces, :gst, :decimal, precision: 5, scale: 3, default: 0.0, null: false
    add_column :provinces, :hst, :decimal, precision: 5, scale: 3, default: 0.0, null: false
  end
end
