class AppController < ApplicationController
    # After login successfully, check role
    def checkRole
        @role_id = OkrUserRole.find_by user_id:(current_user.id)
        @role = OkrRole.find_by id:(@role_id.okr_role_id)
        render json: @role, status: :ok
    end

    def resource_name
      :user
    end
  
    def resource
      @resource ||= User.new
    end
  
    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end
end
