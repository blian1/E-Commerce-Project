class CustomerUser < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  # Validation
  validates :name, presence: true, length: { maximum: 50 }, format: { with: /\A[\w\s\-]+\z/, message: "only allows letters, numbers, spaces, and hyphens" }
  validates :phone_number, format: { with: /\A\d{10,15}\z/, message: "must be a valid phone number" }, allow_blank: true
  validates :address, length: { maximum: 255 }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
