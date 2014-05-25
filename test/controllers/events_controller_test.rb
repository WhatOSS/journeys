require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test ".create creates a new Event with Event.create_with_journey" do

    event_data = {
      slug: "/sites/4324",
    }

    user = User.new(ip: '123.32.234.2')

    user_journey = Journey.new()

    User.expects(:find_or_create_by)
      .with(ip: user.ip)
      .returns(user)

    Journey.expects(:find_or_create_open_journey_for_user)
      .with(user)
      .returns(user_journey)

    Event.expects(:create)
      .with({
        journey: user_journey,
        slug: event_data[:slug]
      })

    @request.env['REMOTE_ADDR'] = user.ip

    post :create, event_data
  end
end
