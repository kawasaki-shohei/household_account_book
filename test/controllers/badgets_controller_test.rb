require 'test_helper'

class BadgetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get badgets_index_url
    assert_response :success
  end

  test "should get new" do
    get badgets_new_url
    assert_response :success
  end

  test "should get edit" do
    get badgets_edit_url
    assert_response :success
  end

end
