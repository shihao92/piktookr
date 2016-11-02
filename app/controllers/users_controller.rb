class UsersController < ApplicationController

  CONST_USER_STATUS = ["active", "inactive"]

  @@editing_user_id = 1

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @employees = OkrUserRole.where(okr_role_id: 9)
    @team_leads = OkrUserRole.where(okr_role_id: 8)
    @admins = OkrUserRole.where(okr_role_id: 7)

    @user_status_selection = CONST_USER_STATUS
    @current_edit_user = User.find(@@editing_user_id)

    pages_initialization
    
    @new_user = User.new

    render 'app/system_users'
  end

  def check_first_time
    user_id = params[:id]
    current_user = User.find(user_id)
    employee_role = OkrRole.find_by(name: "Employee")
    is_first_time = 0
    timeframe_log_id = TimeframeLog.current_timeframe_log_id
    okr_sign_in = OkrSignIn.find_by(user_id: user_id)
    sign_in_count = okr_sign_in.sign_in_count
    respond_to do |format|
      if sign_in_count == 0
        is_first_time = 1
        sign_in_count = sign_in_count + 1
        OkrUserRole.create(user_id: user_id, okr_role_id: employee_role.id)
        OkrSignIn.find_by(user_id: user_id).update(sign_in_count: sign_in_count)
        OkrUserTimeframe.create!(user_id: user_id, timeframe_log_id: timeframe_log_id)
        format.json { render json: is_first_time, status: :ok }
      else
        format.json { render json: is_first_time, status: :ok }
      end
    end
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
    okr_sign_in = OkrSignIn.find_by(user_id: current_user_id)
    okr_user_role = OkrUserRole.find_by(user_id: current_user_id)
    okr_user_timeframe = OkrUserTimeframe.find_by(user_id: current_user_id)
    current_timeframe_log_id = TimeframeLog.current_timeframe_log_id
    if okr_sign_in == nil
      OkrSignIn.create(user_id: current_user_id, sign_in_count: 0)
    end
    if okr_user_role == nil
      OkrUserRole.create(user_id: current_user_id, okr_role_id: params[:role][:id])
    end
    if okr_user_timeframe == nil
      OkrUserTimeframe.create(user_id: current_user_id, timeframe_log_id: current_timeframe_log_id)
    end
    respond_to do |format|
      if User.where(id: current_user_id).update_all(email: user_params["email"], 
                                                    last_name: user_params["last_name"], 
                                                    first_name: user_params["first_name"], 
                                                    status: params[:status][:status_const],
                                                    position: user_params["position"])      
        OkrUserRole.where(user_id: current_user_id).update_all(okr_role_id: params[:role][:id])
        format.html { redirect_to '/users', notice: 'User was successfully updated.' }
      else
        format.html { redirect_to '/users' }
      end
    end
  end

  def user_update_info
    current_user_id = params[:id]
    current_edit_user = User.find(current_user_id)
    current_edit_user.update(user_params.merge(:user_update => true))
    respond_to do |format|
      format.html { redirect_to '/', notice: 'User was successfully updated.' }
    end
  end

  # User update
  def user_update_first_time
    current_user_id = params[:id]
    current_edit_user = User.find(current_user_id)
    respond_to do |format|
      if current_edit_user.update(user_params)      
        format.html { redirect_to '/', notice: 'User was successfully updated.' }
      else
        format.html { redirect_to '/', notice: 'Failed to update password!' }
      end
    end
  end

  # User update
  def user_update
    current_user_id = params[:id]
    current_edit_user = User.find(current_user_id)
    respond_to do |format|
      if current_edit_user.update(password: user_params["password"], password_confirmation: user_params["password_confirmation"])      
        format.html { redirect_to '/', notice: 'User was successfully updated.' }
      else
        format.html { redirect_to '/', notice: 'Failed to update password!' }
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

  # GET /users/:id/notifications_read_status
  def notifications_read_status
    user_id = params[:id]
    status = 0
    notifications = Notification.where(receiver_id: user_id)
    notifications.each do |item|
      if item.read_status == 'PENDING'
        status = 1
      end
    end
    
    respond_to do |format|
      if status == 0 || status == 1
        format.json { render json: status, status: :ok } 
      else
        format.json { render json: 'Fail to get status!', status: :unprocessable_entity }
      end
    end
  end

  # GET /users/:id/update_notification_read_status/:notification_id
  def update_notification_read_status
    notification_id = params[:notification_id]
    respond_to do |format|
      if Notification.where(id: notification_id).update_all(read_status: "READ")
        format.json { render json: 'Read notification!', status: :ok } 
      else
        format.json { render json: 'Fail to update notification status!', status: :unprocessable_entity }
      end
    end
  end

  def favourite_user
    favourite_user_id = params[:fav_user_id]
    status = OkrUserFavourite.insert_favourite_list(current_user.id, favourite_user_id)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Updated favourite user list!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  def remove_favourite_user
    okr_user_fav_id = params[:okr_user_fav_id]
    status = OkrUserFavourite.remove_favourite_id(okr_user_fav_id)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Updated favourite user list!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  def search_user_results
    keyword = params[:keyword]
    current_user_id = current_user.id
    result_users = User.search_user_except_self(keyword, current_user_id)
    respond_to do |format|
      format.json { render json: result_users, status: :ok }  
    end
  end

  def insert_feedback
    feedback_content = params[:content]
    respond_to do |format|
      if Feedback.create!(content: feedback_content, user_id: current_user.id, feedback_status: 'recent')
        format.json { render json: 'Thank you for the feedback :)', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email,  
        :last_name, 
        :first_name, 
        :password,
        :password_confirmation,
        :status, 
        :avatar, 
        :position, 
        :team,
        :user_update
      )
    end

end
