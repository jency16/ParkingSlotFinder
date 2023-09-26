class SlotBookingsController < ApplicationController
  before_action :get_entry_points, only: [:new, :create]

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @slot_bookings = SlotBooking.used_on_date(@date)
  end

  def allocation_history
    @vehicle_number = params[:vehicle_number]
    @slot_bookings = SlotBooking.history(@vehicle_number)
  end

  def first_entry
    @slot_bookings = SlotBooking.select("MIN(entry_time) AS first_entry_time, vehicle_registration_number, slot_id").group(:vehicle_registration_number)
  end

  def my_bookings
    @slot_bookings = SlotBooking.where(user_id: current_user.id)
  end
  def new
    @slot_booking = SlotBooking.new
  end

  def show
    @slot_booking = SlotBooking.find(params[:id])
  end

  def create
    @slot_booking = SlotBooking.new(slot_booking_params)
    @slot_booking.user_id = current_user.id
    @slot_booking.entry_time = Time.now

    if @slot_booking.entry_point.present?
    nearest_slot = find_nearest_available_slot(@slot_booking.entry_point)

    if nearest_slot
      @slot_booking.slot = nearest_slot
      nearest_slot.update(occupied: true)
      if @slot_booking.save
        flash[:success] = "Slot booked successfully! Your nearest slot is #{nearest_slot.number}."
        redirect_to slot_booking_path(@slot_booking)
      else
        flash[:error] = "Failed to book the slot."
        render :new
      end
    else
      flash[:error] = "No available slots at the moment."
      render :new
    end
    else
      render :new
    end
  end

  def cancel
    @slot_booking = SlotBooking.find(params[:id])
    if @slot_booking.cancel
      flash[:success] = "Slot booking has been canceled successfully."
    else
      flash[:error] = "Unable to cancel the slot booking."
    end
    redirect_to new_slot_booking_path
  end


  private

  def get_entry_points
    @entry_points = EntryPoint.all
  end

  def slot_booking_params
    params.require(:slot_booking).permit(:entry_point_id, :vehicle_registration_number)
  end

  def find_nearest_available_slot(entry_point)
    available_slots = Slot.where(occupied: false)
    nearest_slot = nil
    nearest_distance = nil

    available_slots.each do |slot|
      distance = Geocoder::Calculations.distance_between(
        [entry_point.latitude, entry_point.longitude],
        [slot.latitude, slot.longitude]
      )

      if nearest_distance.nil? || distance < nearest_distance
        nearest_slot = slot
        nearest_distance = distance
      end
    end

    nearest_slot
  end

end
