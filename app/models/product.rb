class Product < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "price", "stock_quantity", "category", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # allow upload many images for one product
  has_many_attached :images

  # Validation
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
