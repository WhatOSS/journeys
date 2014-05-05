require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test ".create creates a new Event with Event.create_with_journey" do

    event_data = {
      slug: "/sites/4324",
      user: "the-user"
    }

    user_journey = Journey.new()

    Journey.expects(:find_or_create_open_journey_for_user)
      .with(event_data[:user])
      .returns(user_journey)

    Event.expects(:create)
      .with({
        journey: user_journey,
        slug: event_data[:slug]
      })

    post :create, event_data
  end
end
