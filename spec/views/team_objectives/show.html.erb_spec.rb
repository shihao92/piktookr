require 'rails_helper'

RSpec.describe "team_objectives/show", type: :view do
  before(:each) do
    @team_objective = assign(:team_objective, TeamObjective.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
