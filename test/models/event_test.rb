require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test ".last_for_user_inside_journey_window returns
  the last event for the given user in the last 15 minutes" do
    user = User.create()

    recent_event = Event.create(user: user)

    result = Event.last_for_user_inside_journey_window(user)

    assert_equal recent_event, result,
      "Expected the recent event to be returned"
  end

  test ".last_for_user_inside_journey_window returns
  nil if the only event for that user is older than 15 minutes" do
    user = User.create(ip: '124.124.124.124')

    old_event = Event.create(
      user: user,
      created_at: 16.minutes.ago
    )

    assert_nil Event.last_for_user_inside_journey_window(user),
      "Expected no event to be returned"
  end
end
