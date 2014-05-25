require 'test_helper'

class JourneyTest < ActiveSupport::TestCase

  test ".find_or_create_open_journey_for_user creates a new journey
  for the given user if there is no open journey for that user" do
    user = User.create()
    journey = Journey.find_or_create_open_journey_for_user(user)

    assert_equal journey.user, user,
      "Expected the returned Journey to refer to the given user"

    assert_equal 1, Journey.count,
      "Expected a new journey to be created"

  end

  test ".find_or_create_open_journey_for_user returns the existing
  journey when there exists an open journey for that user" do
    user = User.create()
    existing_journey = Journey.create(
      user: user
    )
    Journey.expects(:find_open_journey_for_user)
      .with(user)
      .returns(existing_journey)

    journey = Journey.find_or_create_open_journey_for_user(user)

    assert_equal journey, existing_journey,
      "Expected the existing journey to be returned"

    assert_equal 1, Journey.count,
      "Expected no new journey to be created"

  end

  test ".find_open_journey_for_user returns the existing
  journey when there exists a journey for the same user which
  has an event in the last 15 minutes" do
    user = User.create()
    open_journey = Journey.create(user: user)
    Event.create(journey: open_journey, user: user)

    journey = Journey.find_open_journey_for_user(user)

    assert_equal open_journey, journey,
      "Expected the existing journey to be returned"
  end

  test ".find_open_journey_for_user returns nil when the most
  recent event for the user is older than 15 minutes" do
    user = User.create(ip: '234.245.234.43')
    open_journey = Journey.create(user: user)
    Event.create(
      user: user,
      journey: open_journey,
      created_at: 16.minutes.ago
    )

    journey = Journey.find_open_journey_for_user(user)

    assert_nil journey, "Expected no journey to be returned"
  end
end
