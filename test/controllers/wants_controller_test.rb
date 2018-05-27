require 'test_helper'

class WantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get wants_index_url
    assert_response :success
  end

end
