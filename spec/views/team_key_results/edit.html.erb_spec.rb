require 'rails_helper'

RSpec.describe "team_key_results/edit", type: :view do
  before(:each) do
    @team_key_result = assign(:team_key_result, TeamKeyResult.create!())
  end

  it "renders the edit team_key_result form" do
    render

    assert_select "form[action=?][method=?]", team_key_result_path(@team_key_result), "post" do
    end
  end
end
