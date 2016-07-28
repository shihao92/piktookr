require 'test_helper'

class OkrTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @okr_team = okr_teams(:one)
  end

  test "should get index" do
    get okr_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_okr_team_url
    assert_response :success
  end

  test "should create okr_team" do
    assert_difference('OkrTeam.count') do
      post okr_teams_url, params: { okr_team: {  } }
    end

    assert_redirected_to okr_team_url(OkrTeam.last)
  end

  test "should show okr_team" do
    get okr_team_url(@okr_team)
    assert_response :success
  end

  test "should get edit" do
    get edit_okr_team_url(@okr_team)
    assert_response :success
  end

  test "should update okr_team" do
    patch okr_team_url(@okr_team), params: { okr_team: {  } }
    assert_redirected_to okr_team_url(@okr_team)
  end

  test "should destroy okr_team" do
    assert_difference('OkrTeam.count', -1) do
      delete okr_team_url(@okr_team)
    end

    assert_redirected_to okr_teams_url
  end
end
