class AppController < ApplicationController
    # After login successfully, check role
    def checkRole
        @role = OkrUserRole.find(current_user.id)
        render json: @role, status: :ok
    end

    
end
