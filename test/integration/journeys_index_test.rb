require 'test_helper'
require 'nokogiri'

class JourneyIndexTest < ActionDispatch::IntegrationTest
  test "Visiting the Journey index shows the lists of recent journeys" do
    journey_one = Journey.create(user: "10.12.13.14")
    journey_two = Journey.create(user: "192.168.1.1")

    get "/journeys"

    assert_response :success

    assert_select ".journeys", {
      count: 1
    }

    page = Nokogiri::HTML(response.body)

    journeys = page.css('.journeys > li')

    assert_equal journeys.length, 2,
      "Expected to see 2 journeys"

    assert_equal journey_one.user, journeys[0].css('.user')[0].content,
      "Expected to see the user for the first journey"
  end
end
