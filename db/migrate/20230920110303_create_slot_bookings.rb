class CreateSlotBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :slot_bookings do |t|
      t.references :entry_point, null: false, foreign_key: true
      t.string :vehicle_registration_number
      t.datetime :entry_time
      t.references :slot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
