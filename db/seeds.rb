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

province_data = {
  "Alberta" => { gst: 0.05, pst: 0.0, hst: 0.0 },
  "British Columbia" => { gst: 0.05, pst: 0.07, hst: 0.0 },
  "Manitoba" => { gst: 0.05, pst: 0.07, hst: 0.0 },
  "New Brunswick" => { gst: 0.0, pst: 0.0, hst: 0.15 },
  "Newfoundland and Labrador" => { gst: 0.0, pst: 0.0, hst: 0.15 },
  "Nova Scotia" => { gst: 0.0, pst: 0.0, hst: 0.15 },
  "Ontario" => { gst: 0.0, pst: 0.0, hst: 0.13 },
  "Prince Edward Island" => { gst: 0.0, pst: 0.0, hst: 0.15 },
  "Quebec" => { gst: 0.05, pst: 0.09975, hst: 0.0 },
  "Saskatchewan" => { gst: 0.05, pst: 0.06, hst: 0.0 },
  "Northwest Territories" => { gst: 0.05, pst: 0.0, hst: 0.0 },
  "Nunavut" => { gst: 0.05, pst: 0.0, hst: 0.0 },
  "Yukon" => { gst: 0.05, pst: 0.0, hst: 0.0 }
}

Province.find_each do |province|
  if province_data.key?(province.name)
    tax_rates = province_data[province.name]
    province.update!(
      gst: tax_rates[:gst],
      pst: tax_rates[:pst],
      hst: tax_rates[:hst]
    )
    puts "Updated #{province.name} with GST: #{tax_rates[:gst]}, PST: #{tax_rates[:pst]}, HST: #{tax_rates[:hst]}"
  else
    puts "No tax data found for #{province.name}, skipping update."
  end
end
