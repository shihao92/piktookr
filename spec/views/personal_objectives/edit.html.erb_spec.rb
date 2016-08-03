require 'rails_helper'

RSpec.describe "personal_objectives/edit", type: :view do
  before(:each) do
    @personal_objective = assign(:personal_objective, PersonalObjective.create!())
  end

  it "renders the edit personal_objective form" do
    render

    assert_select "form[action=?][method=?]", personal_objective_path(@personal_objective), "post" do
    end
  end
end
