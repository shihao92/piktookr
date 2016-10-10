class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  # Went through devise gem for session authentication before going to any action
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Timeframe module
  @@system_timeframe_log_id = TimeframeLog.current_timeframe_log_id

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

  def pages_initialization
    okr_user_timeframe = OkrUserTimeframe.find_by(user_id: current_user.id)
    @selected_timeframe = TimeframeLog.find(okr_user_timeframe.timeframe_log_id)
    @remaining_quarter_days = Timeframe.calculate_remaining_days_current_quarter
    @user = User.find(current_user.id)
    okr_user_role = OkrUserRole.find_by(user_id: current_user.id)
    @role = OkrRole.find(okr_user_role.okr_role_id)

    @controls = initialize_role_control(@role)
  end

private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :last_name, :first_name, :status, :avatar, :position ])
  end 

  def set_timezone(&action)
    Time.use_zone(current_user.time_zone, &action)
  end
  
  def initialize_role_control(role)
    okr_role_controls = OkrRoleControl.where(okr_role_id: role.id)
    controls = []
    okr_role_controls.each do |item|
      control = Control.find(item.control_id)
      controls << control.details
    end
    return controls
  end
end
