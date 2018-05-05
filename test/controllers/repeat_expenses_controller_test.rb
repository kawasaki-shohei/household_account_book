require 'test_helper'

class RepeatExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get repeat_expenses_new_url
    assert_response :success
  end

  test "should get edit" do
    get repeat_expenses_edit_url
    assert_response :success
  end

end
