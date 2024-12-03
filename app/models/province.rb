class Province < ApplicationRecord
  has_many :customer_users


  validates :name, presence: true, uniqueness: true
end
