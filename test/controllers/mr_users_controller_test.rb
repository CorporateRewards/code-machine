require 'test_helper'

class MrUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mr_user = mr_users(:one)
  end

  test "should get index" do
    get mr_users_url
    assert_response :success
  end

  test "should get new" do
    get new_mr_user_url
    assert_response :success
  end

  test "should create mr_user" do
    assert_difference('MrUser.count') do
      post mr_users_url, params: { mr_user: {  } }
    end

    assert_redirected_to mr_user_url(MrUser.last)
  end

  test "should show mr_user" do
    get mr_user_url(@mr_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_mr_user_url(@mr_user)
    assert_response :success
  end

  test "should update mr_user" do
    patch mr_user_url(@mr_user), params: { mr_user: {  } }
    assert_redirected_to mr_user_url(@mr_user)
  end

  test "should destroy mr_user" do
    assert_difference('MrUser.count', -1) do
      delete mr_user_url(@mr_user)
    end

    assert_redirected_to mr_users_url
  end
end
