require 'rails_helper'

RSpec.describe "team_objectives/index", type: :view do
  before(:each) do
    assign(:team_objectives, [
      TeamObjective.create!(),
      TeamObjective.create!()
    ])
  end

  it "renders a list of team_objectives" do
    render
  end
end
