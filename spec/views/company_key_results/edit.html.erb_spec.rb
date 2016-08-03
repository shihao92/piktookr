require 'rails_helper'

RSpec.describe "company_key_results/edit", type: :view do
  before(:each) do
    @company_key_result = assign(:company_key_result, CompanyKeyResult.create!())
  end

  it "renders the edit company_key_result form" do
    render

    assert_select "form[action=?][method=?]", company_key_result_path(@company_key_result), "post" do
    end
  end
end
