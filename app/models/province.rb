class Province < ApplicationRecord
  has_many :customer_users


  # Validation
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :gst, :pst, :hst, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
