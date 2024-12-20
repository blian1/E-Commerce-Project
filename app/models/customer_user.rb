# frozen_string_literal: true

class CustomerUser < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  # Validation
  validates :phone_number, format: { with: /\A\d{10,15}\z/, message: 'must be a valid phone number' }, allow_blank: true
  validates :address, length: { maximum: 255 }, allow_blank: true
  validates :email, presence: false, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
