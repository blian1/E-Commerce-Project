class Category < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end

  has_many :products, dependent: :nullify

  # Validation
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }, format: { with: /\A[\w\s\-]+\z/, message: "only allows letters, numbers, spaces, and hyphens" }
end
