require 'rails_helper'

RSpec.describe "personal_objectives/new", type: :view do
  before(:each) do
    assign(:personal_objective, PersonalObjective.new())
  end

  it "renders new personal_objective form" do
    render

    assert_select "form[action=?][method=?]", personal_objectives_path, "post" do
    end
  end
end
