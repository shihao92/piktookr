class OkrRolesController < ApplicationController

  def index
    @selected_timeframe = TimeframeLog.find(@@system_timeframe_log_id)
    @okr_roles = OkrRole.all

    render 'app/role_security'
  end

  

end
