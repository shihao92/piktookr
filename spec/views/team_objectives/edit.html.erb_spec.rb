require 'rails_helper'

RSpec.describe "team_objectives/edit", type: :view do
  before(:each) do
    @team_objective = assign(:team_objective, TeamObjective.create!())
  end

  it "renders the edit team_objective form" do
    render

    assert_select "form[action=?][method=?]", team_objective_path(@team_objective), "post" do
    end
  end
end
