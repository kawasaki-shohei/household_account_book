require 'test_helper'

class PaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pays_index_url
    assert_response :success
  end

  test "should get new" do
    get pays_new_url
    assert_response :success
  end

  test "should get edit" do
    get pays_edit_url
    assert_response :success
  end

end
