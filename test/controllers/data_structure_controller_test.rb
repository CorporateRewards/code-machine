require 'test_helper'

class DataStructureControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get data_structure_index_url
    assert_response :success
  end

  test "should get new" do
    get data_structure_new_url
    assert_response :success
  end

  test "should get create" do
    get data_structure_create_url
    assert_response :success
  end

  test "should get edit" do
    get data_structure_edit_url
    assert_response :success
  end

  test "should get show" do
    get data_structure_show_url
    assert_response :success
  end

  test "should get destroy" do
    get data_structure_destroy_url
    assert_response :success
  end

end
