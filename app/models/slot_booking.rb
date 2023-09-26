class SlotBooking < ApplicationRecord
  belongs_to :entry_point
  belongs_to :slot

  validates :entry_point_id, presence: true

  validates :vehicle_registration_number, presence: true
  validate :vehicle_can_enter_once_per_day, on: :create

  def vehicle_can_enter_once_per_day
    if SlotBooking.exists?(vehicle_registration_number: vehicle_registration_number, entry_time: entry_time.beginning_of_day..entry_time.end_of_day)
      errors.add(:base, 'Vehicle can enter the parking only once per day')
    end
  end

  def cancel
    return false if canceled?

    self.transaction do
      update(canceled: true, canceled_at: Time.now)

      slot.update(occupied: false) if slot.present?
    end

    true
  end

  scope :used_on_date, ->(date) { where(entry_time: date.beginning_of_day..date.end_of_day) }

  scope :history, ->(vehicle_number) { where(vehicle_registration_number: vehicle_number) }
end
