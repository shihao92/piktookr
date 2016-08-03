require "rails_helper"

RSpec.describe TeamObjectivesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/team_objectives").to route_to("team_objectives#index")
    end

    it "routes to #new" do
      expect(:get => "/team_objectives/new").to route_to("team_objectives#new")
    end

    it "routes to #show" do
      expect(:get => "/team_objectives/1").to route_to("team_objectives#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/team_objectives/1/edit").to route_to("team_objectives#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/team_objectives").to route_to("team_objectives#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/team_objectives/1").to route_to("team_objectives#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/team_objectives/1").to route_to("team_objectives#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/team_objectives/1").to route_to("team_objectives#destroy", :id => "1")
    end

  end
end
