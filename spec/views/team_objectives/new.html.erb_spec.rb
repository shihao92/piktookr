require 'rails_helper'

RSpec.describe "team_objectives/new", type: :view do
  before(:each) do
    assign(:team_objective, TeamObjective.new())
  end

  it "renders new team_objective form" do
    render

    assert_select "form[action=?][method=?]", team_objectives_path, "post" do
    end
  end
end
