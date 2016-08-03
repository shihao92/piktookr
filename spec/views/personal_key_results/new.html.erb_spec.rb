require 'rails_helper'

RSpec.describe "personal_key_results/new", type: :view do
  before(:each) do
    assign(:personal_key_result, PersonalKeyResult.new())
  end

  it "renders new personal_key_result form" do
    render

    assert_select "form[action=?][method=?]", personal_key_results_path, "post" do
    end
  end
end
