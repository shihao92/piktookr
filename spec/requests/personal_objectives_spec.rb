require 'rails_helper'

RSpec.describe "PersonalObjectives", type: :request do
  describe "GET /personal_objectives" do
    it "works! (now write some real specs)" do
      get personal_objectives_path
      expect(response).to have_http_status(200)
    end
  end
end
