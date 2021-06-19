require "test_helper"

class SneakerDbsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sneaker_dbs_index_url
    assert_response :success
  end

  test "should get show" do
    get sneaker_dbs_show_url
    assert_response :success
  end
end
