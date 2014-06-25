require 'test_helper'
require 'nokogiri'

class JourneyIndexTest < ActionDispatch::IntegrationTest
  test "Visiting the Journey index shows the lists of recent journeys" do

    first_journey_date = "2014-03-01 14:32"
    journey_one = Journey.create(
      user: User.create(ip: "10.12.13.14"),
      created_at: Time.parse(first_journey_date)
    )
    journey_two = Journey.create(user: User.create(ip: "192.168.1.1"))

    get "/journeys"

    assert_response :success

    assert_select ".journeys", {
      count: 1
    }

    page = Nokogiri::HTML(response.body)

    journeys = page.css('.journeys > li')

    assert_equal journeys.length, 2,
      "Expected to see 2 journeys"

    assert_equal journey_one.user.ip, journeys[0].css('.user')[0].content,
      "Expected to see the user for the first journey"

    assert_equal first_journey_date, journeys[0].css('.time')[0].content.strip,
      "Expected to see the time the journey started"

    assert_equal(
      1,
      journeys[0].css("a[href='/journeys/#{journey_one.id}']").length,
      "Expected to see the time the journey started"
    )
  end

  test "Journeys on the index show their first visit URL" do
    journey = Journey.create!(user: User.create!())
    first_event = Event.create!(
      journey: journey,
      slug: "http://pretoria.com/spanish"
    )
    second_event = Event.create!(
      journey: journey,
      slug: "http://later.com/"
    )

    get "/journeys"

    assert_response :success

    assert_select '.first-event-url', {
      count: 1
    }

    page = Nokogiri::HTML(response.body)

    first_event_text = page.css('.first-event-url').first.content.strip

    assert_equal first_event.slug, first_event_text
      "Expected the first events text to be shown"
  end

  test "Journeys are listed with their event counts" do
    user = User.create!()
    journey_with_events = Journey.create!(user: user)
    3.times do
      Event.create!(
        journey: journey_with_events,
        slug: "http://pretoria.com/spanish"
      )
    end

    journey_with_no_events = Journey.create!(user: user)

    get "/journeys"

    assert_response :success

    page = Nokogiri::HTML(response.body)

    journeys = page.css('.journeys > li')

    assert_equal journeys.length, 2,
      "Expected to see 2 journeys"

    assert_equal "3 events", journeys[0].css('.event-count')[0].content.strip,
      "Expected to see the correct number of events for the first journey"

    assert_equal "0 events", journeys[1].css('.event-count')[0].content.strip,
      "Expected to see the correct number of events for the second journey"
  end
end
