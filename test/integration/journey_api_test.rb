require 'test_helper'

class JourneyApiTest < ActionDispatch::IntegrationTest
  test "Posting a new event with a user creates a new journey
  and event for that user and slug" do
    event_data = {
      slug: "/sites/4324"
    }

    event_ip = '192.168.4.1'

    post "/events",
      event_data.to_json, {
        "CONTENT_TYPE" => 'application/json',
        "REMOTE_ADDR" => event_ip
      }

    assert_equal 1, Event.count,
      "Expected one event to have been created"

    event = Event.last
    assert_equal event_data[:slug], event.slug,
      "Expected the created event to have the correct slug"

    assert_equal 1, Journey.count,
      "Expected one Journey to have been created"

    assert_not_nil event.journey,
      "Expected the event to be related to a journey"

    journey = Journey.last
    assert_equal journey.id, event.journey_id,
      "Expected the event to be associated to the new journey"

    journey_user = journey.user
    assert_equal event_ip, journey_user.ip,
      "Expected the journey to be associated with a user with
      the correct IP"
  end

  test "Posting a new event for a different user creates a new
  journey for that event" do

    old_journey = Journey.create(
      user: User.create(ip: "123.124.124.253")
    )

    Event.create(
      slug: "/sites/4324",
      journey: old_journey
    )

    event_data = {
      slug: "/sites/4324",
    }

    new_user_ip = "244.244.244.123"
    post "/events",
      event_data.to_json, {
        "CONTENT_TYPE" => 'application/json',
        "REMOTE_ADDR" => new_user_ip
      }

    assert_equal 2, Event.count,
      "Expected one more event to have been created"

    event = Event.last
    journey = event.journey
    assert_not_nil journey,
      "Expected the event to be related to a journey"

    assert_equal new_user_ip, journey.user.ip
      "Expected the created journey to refer to the new user ip"

    assert_equal 2, Journey.count,
      "Expected one more journey to have been created"
  end

  test "Posting a new event for a user with a journey from
  the last 15 minutes associates the new event with that journey" do
    user = User.create(ip: "123.123.123.123")

    existing_journey = Journey.create(
      user: user
    )
    Event.create(journey: existing_journey, user: user)

    event_data = {
      slug: "/sites/4324",
    }

    post "/events",
      event_data.to_json, {
        "CONTENT_TYPE" => 'application/json',
        "REMOTE_ADDR" => user.ip
      }

    assert_equal 2, Event.count,
      "Expected a new event to be created"

    event = Event.last
    assert_equal existing_journey.id, event.journey_id,
      "Expected the event to be associated to the existing journey"

    assert_equal 1, Journey.count,
      "Expected no more Journeys to be created"
  end
end
