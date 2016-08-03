require 'rails_helper'

RSpec.describe "personal_key_results/edit", type: :view do
  before(:each) do
    @personal_key_result = assign(:personal_key_result, PersonalKeyResult.create!())
  end

  it "renders the edit personal_key_result form" do
    render

    assert_select "form[action=?][method=?]", personal_key_result_path(@personal_key_result), "post" do
    end
  end
end
