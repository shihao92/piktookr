Rails.application.routes.draw do
  # ----------------------------------
  # User login and registration module
  # ----------------------------------
  devise_for :users, :controllers => {:registrations => "registrations"}

  # -----------
  # Role module
  # -----------
  # URL to check for role based on input ID
  get 'app/checkRole'
  
  



  # Routes for application view pages
  get 'app/dashboard'
  
  # Route for the default page
  root 'app#dashboard'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
