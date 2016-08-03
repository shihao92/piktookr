require 'rails_helper'

RSpec.describe "company_key_results/index", type: :view do
  before(:each) do
    assign(:company_key_results, [
      CompanyKeyResult.create!(),
      CompanyKeyResult.create!()
    ])
  end

  it "renders a list of company_key_results" do
    render
  end
end
