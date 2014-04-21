require 'test_helper'
require 'nokogiri'

class JourneyShowTest < ActionDispatch::IntegrationTest
  test "visiting a journey shows the list of slugs for the associated events" do
    journey = Journey.create()
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
end
