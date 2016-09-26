class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  # Went through devise gem for session authentication before going to any action
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end

  def verified_request?
    if request.content_type == "application/json"
      true
    else
      super()
    end
  end
private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :last_name, :first_name, :status, :avatar, :position ])
  end 

  def set_timezone(&action)
    Time.use_zone(current_user.time_zone, &action)
  end
end
