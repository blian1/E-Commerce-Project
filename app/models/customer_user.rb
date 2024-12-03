class CustomerUser < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, allow_nil: true
  validates :phone_number, format: { with: /\A\d{10,15}\z/, message: "must be a valid phone number" }, allow_nil: true
  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy
end
