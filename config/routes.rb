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
  # Route to check for role based on input ID
  get 'app/check_role' 
  
  # ---------------
  # OKR Team Module
  # ---------------
  resources :okr_teams
  resources :okr_user_teams

  # ------------------
  # Company OKR Module
  # ------------------
  # resources :company_objectives
  post 'company_objectives' => 'company_objectives#create'
  delete 'company_objectives/:id' => 'company_objectives#destroy'
  resources :company_key_results

  # Route to the company dashboard
  get 'company_objectives/company_dashboard' => 'company_objectives#company_dashboard'
  # Route to company objective details
  get 'company_objectives/details/:id' => 'company_objectives#details'
  # Route to the company key result details
  get 'company_key_results/details/:id' => 'company_key_results#details'
  
  # Route to create company objective
  post 'company_objectives/create_new_objective' => 'company_objectives#create_new_objective'
  # Route to edit company objective
  post 'company_objectives/edit_objective' => 'company_objectives#edit_objective'
  # Route to edit company key result
  post 'company_key_results/edit_key_result' => 'company_key_results#edit_key_result'

  # ---------------
  # Team OKR Module
  # ---------------
  resources :team_objectives
  resources :team_key_results
  # Route to the team dashboard
  get 'team_objectives/team_dashboard/:team_id' => 'team_objectives#team_dashboard'
  # Route to the team objective details
  get 'team/:team_id/team_objectives/details/:id' => 'team_objectives#details'
  # Route to edit the team objective
  post 'team_objectives/edit_objective' => 'team_objectives#edit_objective'
  # Route to the team key result detail page
  get 'team/:team_id/team_key_results/details/:id' => 'team_key_results#details'
  # Route to edit the team key result
  post 'team_key_results/edit_key_result' => 'team_key_results#edit_key_result'

  # -------------------
  # Personal OKR Module
  # -------------------
  resources :personal_objectives
  resources :personal_key_results
  # Route to update the progress of key result
  post 'personal_key_results/update_progress_key_result' => 'personal_key_results#update_progress_key_result'
  # Route to update the status of the key result
  get 'personal_key_results/:id/update_key_result_status/:completed' => 'personal_key_results#update_key_result_status' 
  # Route to edit and save the personal key result
  post 'personal_key_results/edit_key_result' => 'personal_key_results#edit_key_result'

  # Personal contributions upon update the key results progress
  resources :contributions

  # Route to use selected team ID to populate the team key results combo box
  get 'personal_objectives/get_team_key_results/:id' => 'personal_objectives#get_team_key_results' 

  # Route for the personal objective details page
  get 'personal_objectives/details/:id' => 'personal_objectives#details'
  # Route for the personal key result details page
  get 'personal_key_results/details/:id' => 'personal_key_results#details'
  # Route to view other person personal OKR
  get 'personal_objectives/view_others_personal_okr/:user_id' => 'personal_objectives#view_others_personal_okr'
  # Route to edit the personal objective
  post 'personal_objectives/edit_objective' => 'personal_objectives#edit_objective'
  
  # Route for application view pages
  # Prototype 1
  get 'app/dashboard'
  # Prototype 2
  get 'app/dashboard_v2' => 'app#dashboard_v2'
  # Route for the default page
  root 'app#dashboard_v2' 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
