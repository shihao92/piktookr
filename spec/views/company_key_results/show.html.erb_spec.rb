require 'rails_helper'

RSpec.describe "company_key_results/show", type: :view do
  before(:each) do
    @company_key_result = assign(:company_key_result, CompanyKeyResult.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
