require 'rails_helper'

RSpec.describe "personal_key_results/index", type: :view do
  before(:each) do
    assign(:personal_key_results, [
      PersonalKeyResult.create!(),
      PersonalKeyResult.create!()
    ])
  end

  it "renders a list of personal_key_results" do
    render
  end
end
