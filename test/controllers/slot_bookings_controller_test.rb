require "test_helper"

class SlotBookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get slot_bookings_new_url
    assert_response :success
  end

  test "should get create" do
    get slot_bookings_create_url
    assert_response :success
  end
end
