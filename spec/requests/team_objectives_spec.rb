require 'rails_helper'

RSpec.describe "TeamObjectives", type: :request do
  describe "GET /team_objectives" do
    it "works! (now write some real specs)" do
      get team_objectives_path
      expect(response).to have_http_status(200)
    end
  end
end
