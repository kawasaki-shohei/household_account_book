require 'test_helper'

class BoughtButtonsControllerTest < ActionDispatch::IntegrationTest
  test "should get bought" do
    get bought_buttons_bought_url
    assert_response :success
  end

  test "should get not_yet" do
    get bought_buttons_not_yet_url
    assert_response :success
  end

end
