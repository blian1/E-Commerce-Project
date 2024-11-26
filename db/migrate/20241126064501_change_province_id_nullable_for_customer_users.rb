class ChangeProvinceIdNullableForCustomerUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :customer_users, :province_id, true
  end
end
