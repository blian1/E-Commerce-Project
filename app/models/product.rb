class Product < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "price", "stock_quantity", "category", "created_at", "updated_at" ]
  end

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
