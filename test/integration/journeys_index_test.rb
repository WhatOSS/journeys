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
end
