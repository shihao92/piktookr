class UsersController < ApplicationController

  CONST_USER_STATUS = ["ACTIVE", "INACTIVE"]

  @@editing_user_id = 1

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @employees = OkrUserRole.where(okr_role_id: 2)
    @team_leads = OkrUserRole.where(okr_role_id: 1)
    @admins = OkrUserRole.where(okr_role_id: 0)

    @user_status_selection = CONST_USER_STATUS
    @current_edit_user = User.find(@@editing_user_id)
    
    @user = User.new

    render 'app/system_users'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @@editing_user_id = params[:id]

    respond_to do |format|      
      format.html { redirect_to '/users/:edit_user=true', notice: 'User was successfully created.' }
    end 
  end

  # POST /users
  # POST /users.json
  def create_member
    @user = User.new(user_params.merge(status: params[:status][:status_const]))

    respond_to do |format|
      if @user.save      
        OkrUserRole.create!(user_id: @user.id, okr_role_id: params[:role][:role_id])
        format.html { redirect_to '/users/:user_created=true', notice: 'User was successfully created.' }
      else
        format.html { redirect_to '/users/:user_created=false', notice: 'Error!' }
      end
    end
  end

  # POST /users/edit_team
  # POST /users.json
  def edit_team
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully added into the team.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Admin update only
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    current_user_id = params[:id]
    current_edit_user = User.find(current_user_id)
    respond_to do |format|
      if current_edit_user.update(user_params)      
        OkrUserRole.where(user_id: current_user_id).update_all(okr_role_id: params[:role][:role_id])
        format.html { redirect_to '/users', notice: 'User was successfully updated.' }
      else
        format.html { redirect_to '/users' }
      end
    end
  end

  # User update
  def user_update
    current_user_id = params[:id]
    current_edit_user = User.find(current_user_id)
    respond_to do |format|
      if current_edit_user.update(user_params)      
        format.html { redirect_to '/', notice: 'User was successfully updated.' }
      else
        format.html { redirect_to '/' }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    user_id = params[:id]
    status = User.remove_user(user_id)
    respond_to do |format|
      if status == 200
        format.json { render json: 'User is removed successfully!', status: :ok } 
      else
        format.json { render json: 'Fail to remove user!', status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email, 
        :password,  
        :last_name, 
        :first_name, 
        :status, 
        :avatar, 
        :position, 
        :team
      )
    end
end
