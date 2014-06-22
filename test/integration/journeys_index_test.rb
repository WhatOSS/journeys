require 'test_helper'
require 'nokogiri'

class JourneyIndexTest < ActionDispatch::IntegrationTest
  test "Visiting the Journey index shows the lists of recent journeys" do

    first_journey_date = "2014-03-01 14:32"
    older_journey = Journey.create(
      user: User.create(ip: "10.12.13.14"),
      created_at: Time.parse(first_journey_date)
    )
    newer_journey = Journey.create(
      user: User.create(ip: "192.168.1.1"),
      created_at: Time.parse(first_journey_date) + 1.days
    )

    get "/journeys"

    assert_response :success

    assert_select ".journeys", {
      count: 1
    }

    page = Nokogiri::HTML(response.body)

    journeys = page.css('.journeys > li')

    assert_equal journeys.length, 2,
      "Expected to see 2 journeys"

    assert_equal older_journey.user.ip, journeys[1].css('.user')[0].content,
      "Expected to see the user for the first journey"

    assert_equal first_journey_date, journeys[1].css('.time')[0].content.strip,
      "Expected to see the time the journey started"

    assert_equal(
      1,
      journeys[1].css("a[href='/journeys/#{older_journey.id}']").length,
      "Expected to see a link to the journey"
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

    assert_equal "0 events", journeys[0].css('.event-count')[0].content.strip,
      "Expected to see the correct number of events for the second journey"

    assert_equal "3 events", journeys[1].css('.event-count')[0].content.strip,
      "Expected to see the correct number of events for the first journey"
  end

  test "Journeys index only shows the 10 most recent journeys" do
    user = User.create!()
    old_journey = Journey.create!(
      user: user,
      created_at: 5.minutes.ago
    )

    11.times do
      Journey.create!(user: user)
    end

    get "/journeys"

    assert_response :success

    page = Nokogiri::HTML(response.body)

    journeys = page.css('.journeys > li')

    assert_equal 10, journeys.length,
      "Expected to see only 10 journeys"

    old_journey_links = page.css("a[href=\"/journeys/#{old_journey.id}\"]")
    assert_equal 0, old_journey_links.length,
      "Expected not to see a link to the older journey"
  end

  test "Journey list shows 10 journeys for the given page" do
    user = User.create!()
    # First page journeys
    newest_journey = Journey.create!(
      user: user
    )

    9.times do
      Journey.create!(
        user: user
      )
    end

    # Second page journeys
    second_page_journey = Journey.create!(
      user: user,
      created_at: 2.minutes.ago
    )

    9.times do
      Journey.create!(
        user: user,
        created_at: 2.minutes.ago
      )
    end

    oldest_journey = Journey.create!(
      user: user,
      created_at: 3.minutes.ago
    )

    get "/partials/journeys?page=2"

    page = Nokogiri::HTML(response.body)

    journeys = page.css('li')

    assert_equal 10, journeys.length,
      "Expected to see only 10 journeys"

    new_journey_links = page.css("a[href=\"/journeys/#{newest_journey.id}\"]")
    assert_equal 0, new_journey_links.length,
      "Expected not to see a link to the newest journey"

    second_page_journey_links = page.css(
      "a[href=\"/journeys/#{second_page_journey.id}\"]"
    )
    assert_equal 1, second_page_journey_links.length,
      "Expected to see a link to the the second page journey"

    old_journey_links = page.css("a[href=\"/journeys/#{oldest_journey.id}\"]")
    assert_equal 0, old_journey_links.length,
      "Expected not to see a link to the older journey"
  end
end
