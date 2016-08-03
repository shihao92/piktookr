require "rails_helper"

RSpec.describe PersonalObjectivesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/personal_objectives").to route_to("personal_objectives#index")
    end

    it "routes to #new" do
      expect(:get => "/personal_objectives/new").to route_to("personal_objectives#new")
    end

    it "routes to #show" do
      expect(:get => "/personal_objectives/1").to route_to("personal_objectives#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/personal_objectives/1/edit").to route_to("personal_objectives#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/personal_objectives").to route_to("personal_objectives#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/personal_objectives/1").to route_to("personal_objectives#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/personal_objectives/1").to route_to("personal_objectives#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/personal_objectives/1").to route_to("personal_objectives#destroy", :id => "1")
    end

  end
end
