class ChangeDefaultOnSaleInProducts < ActiveRecord::Migration[7.2]
  def change
    change_column_default :products, :on_sale, from: nil, to: true
    change_column_null :products, :on_sale, false, true
  end
end
