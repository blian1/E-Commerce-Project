class SetDefaultProvinceForCustomerUsers < ActiveRecord::Migration[7.2]
  def up
    default_province = Province.find_by(name: "Manitoba") # 替换为合适的默认省份


    if default_province
      CustomerUser.update_all(province_id: default_province.id)
    else

      raise ActiveRecord::RecordNotFound, "Default province not found! Please add a province named 'Manitoba' or update the migration."
    end


    change_column_null :customer_users, :province_id, false
  end

  def down
    change_column_null :customer_users, :province_id, true
  end
end
