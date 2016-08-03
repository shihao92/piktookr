require 'rails_helper'

RSpec.describe "team_key_results/new", type: :view do
  before(:each) do
    assign(:team_key_result, TeamKeyResult.new())
  end

  it "renders new team_key_result form" do
    render

    assert_select "form[action=?][method=?]", team_key_results_path, "post" do
    end
  end
end
