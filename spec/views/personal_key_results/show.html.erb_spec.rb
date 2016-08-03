require 'rails_helper'

RSpec.describe "personal_key_results/show", type: :view do
  before(:each) do
    @personal_key_result = assign(:personal_key_result, PersonalKeyResult.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
