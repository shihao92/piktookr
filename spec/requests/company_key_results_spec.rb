require 'rails_helper'

RSpec.describe "CompanyKeyResults", type: :request do
  describe "GET /company_key_results" do
    it "works! (now write some real specs)" do
      get company_key_results_path
      expect(response).to have_http_status(200)
    end
  end
end
