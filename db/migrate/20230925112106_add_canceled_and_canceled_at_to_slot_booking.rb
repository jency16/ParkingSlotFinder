class AddCanceledAndCanceledAtToSlotBooking < ActiveRecord::Migration[6.1]
  def change
    add_column :slot_bookings, :canceled, :boolean
    add_column :slot_bookings, :canceled_at, :datetime
  end
end
