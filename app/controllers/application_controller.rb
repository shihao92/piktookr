class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  # Went through devise gem for session authentication before going to any action
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :name, :status, :avatar ])
  end 
end
