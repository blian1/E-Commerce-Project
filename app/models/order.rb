class Order < ApplicationRecord
  belongs_to :customer_user
  has_many :order_items, dependent: :destroy
end
