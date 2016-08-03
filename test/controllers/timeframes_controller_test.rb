require 'test_helper'

class TimeframesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timeframe = timeframes(:one)
  end

  test "should get index" do
    get timeframes_url
    assert_response :success
  end

  test "should get new" do
    get new_timeframe_url
    assert_response :success
  end

  test "should create timeframe" do
    assert_difference('Timeframe.count') do
      post timeframes_url, params: { timeframe: {  } }
    end

    assert_redirected_to timeframe_url(Timeframe.last)
  end

  test "should show timeframe" do
    get timeframe_url(@timeframe)
    assert_response :success
  end

  test "should get edit" do
    get edit_timeframe_url(@timeframe)
    assert_response :success
  end

  test "should update timeframe" do
    patch timeframe_url(@timeframe), params: { timeframe: {  } }
    assert_redirected_to timeframe_url(@timeframe)
  end

  test "should destroy timeframe" do
    assert_difference('Timeframe.count', -1) do
      delete timeframe_url(@timeframe)
    end

    assert_redirected_to timeframes_url
  end
end
