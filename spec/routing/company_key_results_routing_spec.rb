require "rails_helper"

RSpec.describe CompanyKeyResultsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/company_key_results").to route_to("company_key_results#index")
    end

    it "routes to #new" do
      expect(:get => "/company_key_results/new").to route_to("company_key_results#new")
    end

    it "routes to #show" do
      expect(:get => "/company_key_results/1").to route_to("company_key_results#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/company_key_results/1/edit").to route_to("company_key_results#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/company_key_results").to route_to("company_key_results#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/company_key_results/1").to route_to("company_key_results#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/company_key_results/1").to route_to("company_key_results#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/company_key_results/1").to route_to("company_key_results#destroy", :id => "1")
    end

  end
end
