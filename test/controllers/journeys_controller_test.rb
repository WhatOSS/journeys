require 'test_helper'
require 'mocha/mini_test'

class JourneysControllerTest < ActionController::TestCase
  test "show loads the given journey and its events" do
    journey = Journey.new(id: 5)

    Journey.expects(:find).with(journey.id.to_s).returns(journey)

    journey.expects(:events).returns([])

    get :show, id: journey.id

    assert_response :success
    assert_equal journey, assigns(:journey)
    assert_equal [], assigns(:events)
  end
end
