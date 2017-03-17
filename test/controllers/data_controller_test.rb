require 'test_helper'

class DataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get data_index_url
    assert_response :success
  end

  test "should get new" do
    get data_new_url
    assert_response :success
  end

  test "should get create" do
    get data_create_url
    assert_response :success
  end

  test "should get edit" do
    get data_edit_url
    assert_response :success
  end

  test "should get show" do
    get data_show_url
    assert_response :success
  end

  test "should get destroy" do
    get data_destroy_url
    assert_response :success
  end

end
