class RegistrationsController < Devise::RegistrationsController
    def new
        super
        
    end

    def create
        super
        # Last part of registrations here
        if resource.persisted?
          role_id = params[:role][:role_id]
          OkrUserRole.create!(user_id: resource.id, okr_role_id: role_id)
        end
    end

    
    
end
