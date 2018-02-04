require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get expenses_index_url
    assert_response :success
  end

  test "should get new" do
    get expenses_new_url
    assert_response :success
  end

  test "should get edit" do
    get expenses_edit_url
    assert_response :success
  end

end
