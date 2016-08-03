require 'rails_helper'

RSpec.describe "team_key_results/show", type: :view do
  before(:each) do
    @team_key_result = assign(:team_key_result, TeamKeyResult.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
