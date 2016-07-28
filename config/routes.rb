Rails.application.routes.draw do
  
  # ----------------------------------
  # User login and registration module
  # ----------------------------------
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users, except: :create do
    collection do
      post :create_member
    end
  end

  # -----------
  # Role module
  # -----------
  # URL to check for role based on input ID
  get 'app/checkRole'
  
  # ---------------
  # OKR Team Module
  # ---------------
  resources :okr_teams
  # resources :okr_user_teams
  


  # Routes for application view pages
  get 'app/dashboard'
  
  # Route for the default page
  root 'app#dashboard'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
