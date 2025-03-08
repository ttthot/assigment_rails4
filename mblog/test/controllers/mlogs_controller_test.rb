require "test_helper"

class MlogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mlogs_index_url
    assert_response :success
  end
end
