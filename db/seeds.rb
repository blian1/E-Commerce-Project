# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Province.create!([
  { name: "Alberta" },
  { name: "British Columbia" },
  { name: "New Brunswick" },
  { name: "Newfoundland and Labrador" },
  { name: "Nova Scotia" },
  { name: "Ontario" },
  { name: "Prince Edward Island" },
  { name: "Quebec" },
  { name: "Saskatchewan" },
  { name: "Northwest Territories" },
  { name: "Nunavut" },
  { name: "Yukon" }
])
