class ChangeNameAndPhoneToNullableInCustomerUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :customer_users, :name, true
    change_column_null :customer_users, :phone_number, true
  end
end
