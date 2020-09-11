require 'test_helper'

class PlanRegisterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get plan_register_index_url
    assert_response :success
  end

  test "should get show" do
    get plan_register_show_url
    assert_response :success
  end

  test "should get create" do
    get plan_register_create_url
    assert_response :success
  end

end
