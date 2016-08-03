require 'rails_helper'

RSpec.describe "team_key_results/index", type: :view do
  before(:each) do
    assign(:team_key_results, [
      TeamKeyResult.create!(),
      TeamKeyResult.create!()
    ])
  end

  it "renders a list of team_key_results" do
    render
  end
end
