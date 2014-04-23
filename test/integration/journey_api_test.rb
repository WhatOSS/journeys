require 'test_helper'

class JourneyApiTest < ActionDispatch::IntegrationTest
  test "Posting a new event with a user creates a new journey
  and event for that user and slug" do
    event_data = {
      slug: "/sites/4324",
      user: "10.1.1.5"
    }

    post "/events",
      event_data.to_json,
      "CONTENT_TYPE" => 'application/json'

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

    assert_equal event_data[:user], journey.user,
      "Expected the journey to reference the same user"
  end

  test "Posting a new event for a different user creates a new
  journey for that event" do

    old_journey = Journey.create(
      user: 'some-old-user'
    )

    Event.create(
      slug: "/sites/4324",
      journey: old_journey
    )

    event_data = {
      slug: "/sites/4324",
      user: "different-user"
    }

    post "/events",
      event_data.to_json,
      "CONTENT_TYPE" => 'application/json'

    assert_equal 2, Event.count,
      "Expected one more event to have been created"

    event = Event.last
    journey = event.journey
    assert_not_nil journey,
      "Expected the event to be related to a journey"

    assert_equal 'different-user', journey.user
      "Expected the created journey to refer to the new user"

    assert_equal 2, Journey.count,
      "Expected one more journey to have been created"
  end

  test "Posting a new event for a user with a journey from
  the last 15 minutes associates the new event with that journey" do

    existing_journey = Journey.create(
      user: 'the-user'
    )

    event_data = {
      slug: "/sites/4324",
      user: "the-user"
    }

    post "/events",
      event_data.to_json,
      "CONTENT_TYPE" => 'application/json'

    assert_equal 1, Event.count,
      "Expected an event to be created"

    event = Event.last
    assert_equal existing_journey.id, event.journey_id,
      "Expected the event to be associated to the existing journey"

    assert_equal 1, Journey.count,
      "Expected no more Journeys to be created"
  end
end
