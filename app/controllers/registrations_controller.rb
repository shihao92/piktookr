class RegistrationsController < Devise::RegistrationsController
    def new
        super
    end

    def create
        super
        # Post-Registrations - Get the user_id and tie it with role selected
        if resource.persisted?
          role_id = params[:role][:role_id]
          OkrUserRole.create!(user_id: resource.id, okr_role_id: role_id)
        end
        flash[:notice] = "Successfully created user."
    end
end
