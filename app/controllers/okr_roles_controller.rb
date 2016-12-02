class OkrRolesController < ApplicationController

  def index
    pages_initialization

    @okr_roles = OkrRole.all
    @control_types = ControlType.all

    render 'app/role_security'
  end

  def create
    role_name = params[:role_name]
    role_description = params[:description]
    respond_to do |format|
      if OkrRole.create!(name: role_name, description: role_description)
        format.json { render json: 'Role is created successfully!', status: :ok }
      else
        format.json { render json: 'Fail to create role!', status: :unprocessable_entity }
      end
    end
  end

  def insert_new_role_control
    okr_role_id = params[:okr_role_id]
    control_id = params[:control_id]
    respond_to do |format|
      if OkrRoleControl.create!(okr_role_id: okr_role_id, control_id: control_id)
        format.json { render json: 'Control for role is created successfully!', status: :ok }
      else
        format.json { render json: 'Fail to create control!', status: :unprocessable_entity }
      end
    end
  end

  def remove_role_control
    okr_role_id = params[:okr_role_id]
    control_id = params[:control_id]
    respond_to do |format|
      if OkrRoleControl.find_by(okr_role_id: okr_role_id, control_id: control_id).destroy
        format.json { render json: 'Control for role is removed successfully!', status: :ok }
      else
        format.json { render json: 'Fail to remove control!', status: :unprocessable_entity }
      end
    end
  end

end
