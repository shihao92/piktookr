Rails.application.routes.draw do
  
  # ----------------------------------
  # User login and registration module
  # ----------------------------------
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users, except: [:create, :show] do
    collection do
      get ':user_created' => 'users#index' 
      post :create_member
      post :edit_team
    end

    member do
      patch :user_update
      put   :user_update

      patch :user_update_info
      put   :user_update_info

      resources :personal_objectives, only: [:view_others_personal_okr] do
        collection do
          # Route to view other person personal OKR
          get   :view_others_personal_okr
        end
      end

      get   :check_first_time

      # Notifications section
      get   :notifications_read_status
      get   'update_notification_read_status/:notification_id' => 'users#update_notification_read_status'      
    end
  end

  # -------------------------
  # Roles and Security Module
  # -------------------------

  resources :okr_roles, path: 'role'

  # ----------------
  # Timeframe module
  # ----------------
  resources :timeframes do
    member do
      get   :set_system_timeframe_log_id
    end
    collection do
      get   :get_current_quarter_end_date
    end
  end
  
  # ---------------
  # OKR Team Module
  # ---------------
  resources :okr_teams, path: 'team' do

    collection do
      post  :remove_user_from_team

      # ------------
      # Notification
      # ------------
    
      post  :accept_team_invitation
    end

    member do
      post  :get_team_info
      post  :invite_to_team   
    end

    # ---------------
    # Team OKR Module
    # ---------------

    resources :team_objectives do
      member do
        # Route to the team objective detail page
        get :details
        # Route to edit the team objective
        post :edit_objective
      end
      collection do
        # Route to the team dashboard
        get :team_dashboard, shallow: true
      end
    end

    resources :team_key_results do
      member do
        # Route to the team key result detail page
        get   :details
        # Route to edit the team key result
        post  :edit_key_result
        # Route to update due date
        post  :insert_due_date
      end
    end

  end

  resources :okr_user_teams

  # ------------------
  # Company OKR Module
  # ------------------
  resources :company_objectives, except: [:index, :show] do

    collection do
      # Route to the company dashboard
      get   :company_dashboard
      # Route to create company objective
      post  :create_new_objective
      # Route to edit company objective
      post  :edit_objective
    end

    member do
      # Route to company objective details
      get   :details
    end  

  end
  
  resources :company_key_results do
    member do
      # Route to the company key result details
      get   :details
      # Route to update due date
      post  :insert_due_date
    end
    collection do
      # Route to edit company key result
      post  :edit_key_result
    end
  end

  # -------------------
  # Personal OKR Module
  # -------------------
  resources :personal_objectives do

    member do
      # Route for the personal objective details page
      get   :details
      # Route to edit the personal objective
      post  :edit_objective
    end

    collection do

    end

  end

  resources :personal_key_results do
    
    member do
      # Route to update the progress of key result
      post  :update_progress_key_result
      # Route to update the status of completion for the key result
      post  :update_key_result_status
      # Route to edit and save the personal key result
      post  :edit_key_result
      # Route for the personal key result details page
      get   :details
      # Route to update due date
      post  :insert_due_date
    end

  end

  # Route for application view pages
  # Prototype 1
  # get 'app/dashboard'
  # Prototype 2
  resources :app, only: :dashboard_v2 do
    collection do
      get   :dashboard_v2
    end 
  end
  
  # Route for the default page
  root 'app#dashboard_v2' 

end
