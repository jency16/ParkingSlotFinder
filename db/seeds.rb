# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Seed entry points
EntryPoint.create(name: 'Entry Point 1', latitude: 40.7128, longitude: -74.0060)
EntryPoint.create(name: 'Entry Point 2', latitude: 34.0522, longitude: -118.2437)
EntryPoint.create(name: 'Entry Point 3', latitude: 51.5074, longitude: -0.1278)
EntryPoint.create(name: 'Entry Point 4', latitude: 48.8566, longitude: 2.3522)

# Seed slots
(1..1000).each do |number|
  Slot.create(number: number, latitude: rand(30.0..50.0), longitude: rand(-120.0..120.0), occupied: false)
end
