require "test_helper"

class Mblogs1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mblogs1_index_url
    assert_response :success
  end
end
