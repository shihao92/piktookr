class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  # Went through devise gem for session authentication before going to any action
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # def after_sign_in_path_for(resource)
  #   sign_in_url = new_user_session_url
  #   if request.referer == sign_in_url
  #     super
  #   else
  #     stored_location_for(resource) || request.referer || root_path
  #   end
  # end
  
private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :name, :status, :avatar ])
  end 

  def set_timezone(&action)
    Time.use_zone(current_user.time_zone, &action)
  end
end
