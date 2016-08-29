Rails.application.routes.draw do
  
  # ----------------------------------
  # User login and registration module
  # ----------------------------------
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users, except: :create do
    collection do
      post :create_member
      post :edit_team
    end
  end

  # ----------------
  # Timeframe module
  # ----------------
  resources :timeframes
  
  # -----------
  # Role module
  # -----------
  # URL to check for role based on input ID
  get 'app/check_role' 
  
  # ---------------
  # OKR Team Module
  # ---------------
  resources :okr_teams
  resources :okr_user_teams

  # ------------------
  # Company OKR Module
  # ------------------
  resources :company_objectives
  resources :company_key_results
  
  # ---------------
  # Team OKR Module
  # ---------------
  resources :team_objectives
  resources :team_key_results
  # URL to use selected team ID to populate the team objectives combo box
  get 'team_key_results/get_team_objective/:id' => 'team_key_results#get_team_objective'

  # -------------------
  # Personal OKR Module
  # -------------------
  resources :personal_objectives
  resources :personal_key_results
  
  # Personal contributions upon update the key results progress
  resources :contributions

  # URL to use selected team ID to populate the team key results combo box
  get 'personal_objectives/get_team_key_results/:id' => 'personal_objectives#get_team_key_results' 

  # Routes for application view pages
  get 'app/dashboard'
  
  # Route for the default page
  root 'app#dashboard_v2'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
