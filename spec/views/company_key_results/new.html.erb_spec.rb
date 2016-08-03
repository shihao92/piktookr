require 'rails_helper'

RSpec.describe "company_key_results/new", type: :view do
  before(:each) do
    assign(:company_key_result, CompanyKeyResult.new())
  end

  it "renders new company_key_result form" do
    render

    assert_select "form[action=?][method=?]", company_key_results_path, "post" do
    end
  end
end
