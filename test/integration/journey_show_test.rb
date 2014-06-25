require 'test_helper'
require 'nokogiri'

class JourneyShowTest < ActionDispatch::IntegrationTest
  test "visiting a journey shows the list of slugs for the associated events" do
    journey = Journey.create(user: User.create())
    Event.create({
      journey: journey,
      slug: "/"
    })
    Event.create({
      journey: journey,
      slug: "/search?q=\"peaches\""
    })

    get "/journeys/#{journey.id}"

    assert_response :success

    assert_select ".events", {
      count: 1
    }

    page = Nokogiri::HTML(response.body)

    events = page.css('.events > li')

    assert_equal events.length, 2,
      "Expected to see both events"

    assert_equal '/', events[0].css('.slug')[0].content,
      "Expected to see the slug for the first event"

    assert_equal '/search?q="peaches"', events[1].css('.slug')[0].content,
      "Expected to see the slug for the first event"
  end

  test "visiting a journey shows the time next to the first event,
  and the time that passes to the second event" do
    event_start = 5.minutes.ago
    journey = Journey.create!(user: User.create())
    Event.create!(journey: journey, created_at: event_start)
    second_event_time = event_start + 2.minutes
    Event.create!(journey: journey, created_at: second_event_time)

    get "/journeys/#{journey.id}"

    assert_response :success

    page = Nokogiri::HTML(response.body)

    events = page.css('.events > li')

    assert_equal(
      event_start.strftime("%H:%M:%S"),
      events.first.css('.time').first.content.strip,
      "Expected to see the correct time on the first event"
    )

    assert_equal(
      second_event_time.strftime("%H:%M:%S"),
      events.last.css('.time').first.content.strip,
      "Expected to see the correct time on the second event"
    )
  end

end
