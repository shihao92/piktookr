require 'rails_helper'

RSpec.describe "personal_objectives/index", type: :view do
  before(:each) do
    assign(:personal_objectives, [
      PersonalObjective.create!(),
      PersonalObjective.create!()
    ])
  end

  it "renders a list of personal_objectives" do
    render
  end
end
