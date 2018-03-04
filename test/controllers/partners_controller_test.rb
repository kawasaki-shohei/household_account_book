require 'test_helper'

class PartnersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get partners_new_url
    assert_response :success
  end

end
