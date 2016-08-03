require 'rails_helper'

RSpec.describe "personal_objectives/show", type: :view do
  before(:each) do
    @personal_objective = assign(:personal_objective, PersonalObjective.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
