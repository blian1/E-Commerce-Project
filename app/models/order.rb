class Order < ApplicationRecord
  belongs_to :customer_user
  has_many :order_items, dependent: :destroy
  STATUSES = %w[unpaid paid shipped completed]
  validates :status, inclusion: { in: STATUSES }
end
