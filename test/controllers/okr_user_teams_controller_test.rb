require 'test_helper'

class OkrUserTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @okr_user_team = okr_user_teams(:one)
  end

  test "should get index" do
    get okr_user_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_okr_user_team_url
    assert_response :success
  end

  test "should create okr_user_team" do
    assert_difference('OkrUserTeam.count') do
      post okr_user_teams_url, params: { okr_user_team: {  } }
    end

    assert_redirected_to okr_user_team_url(OkrUserTeam.last)
  end

  test "should show okr_user_team" do
    get okr_user_team_url(@okr_user_team)
    assert_response :success
  end

  test "should get edit" do
    get edit_okr_user_team_url(@okr_user_team)
    assert_response :success
  end

  test "should update okr_user_team" do
    patch okr_user_team_url(@okr_user_team), params: { okr_user_team: {  } }
    assert_redirected_to okr_user_team_url(@okr_user_team)
  end

  test "should destroy okr_user_team" do
    assert_difference('OkrUserTeam.count', -1) do
      delete okr_user_team_url(@okr_user_team)
    end

    assert_redirected_to okr_user_teams_url
  end
end
