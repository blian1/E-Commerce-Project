class Order < ApplicationRecord
  belongs_to :customer_user
  has_many :order_items, dependent: :destroy
  STATUSES = %w[unpaid paid shipped completed]
  validates :status, inclusion: { in: STATUSES }

  def self.ransackable_associations(auth_object = nil)
    %w[customer_user order_items]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[status total_price created_at updated_at]
  end

  def gst
    (subtotal * customer_user.province.gst).round(2)
  end

  def pst
    (subtotal * customer_user.province.pst).round(2)
  end

  def hst
    (subtotal * customer_user.province.hst).round(2)
  end

  def subtotal
    order_items.sum { |item| (item.quantity * item.price).round(2) }
  end

  def total_price
    (subtotal + gst + pst + hst).round(2)
  end

  # Validation
  validates :status, presence: true, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
