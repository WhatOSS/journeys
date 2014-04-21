require 'test_helper'

class JourneyApiTest < ActionDispatch::IntegrationTest
  test "Posting a new event with a slug creates a new journey and event" do
    event_data = {
      slug: "/sites/4324"
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
  end
end
