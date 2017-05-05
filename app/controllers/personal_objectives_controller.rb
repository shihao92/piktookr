class PersonalObjectivesController < ApplicationController
  before_action :set_personal_objective, only: [:edit, :update, :destroy]

  # GET /personal_objectives/new
  def new
    @personal_objective = PersonalObjective.new
  end

  # GET /personal_objectives/1/edit
  def edit
  end

  # POST /personal_objectives
  # POST /personal_objectives.json
  def create
    objective = params[:objective]
    team_key_result_id = params[:team_key_result_id]
    status = PersonalObjective.new_personal_objective(objective, team_key_result_id, current_user.id)
    respond_to do |format| 
      if status == 200
        format.json { render json: 'Personal Objective is created successfully!', status: :ok }
      else
        format.json { render json: 'Personal Objective must be more than 5 characters!', status: :ok }
      end
    end
  end

  # POST /personal_objectives/create_linked_company
  # POST /personal_objectives.json
  def create_linked_company
    objective = params[:objective]
    company_key_result_id = params[:company_key_result_id]
    status = PersonalObjective.new_personal_objective_linked_company(objective, company_key_result_id, current_user.id)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Personal Objective is created successfully!', status: :ok }
      else
        format.json { render json: 'Personal Objective must be more than 5 characters!', status: :ok }
      end
    end
  end

  # PATCH/PUT /personal_objectives/1
  # PATCH/PUT /personal_objectives/1.json
  def update
    respond_to do |format|
      if @personal_objective.update(personal_objective_params)
        # Right after update progress of personal objective, update OKR progress 
        # update_okr_modules(@personal_objective.id,@personal_objective.progress)
        format.html { redirect_to @personal_objective, notice: 'Personal objective was successfully updated.' }
        format.json { render :show, status: :ok, location: @personal_objective }
      else
        format.html { render :edit }
        format.json { render json: @personal_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_objectives/1
  # DELETE /personal_objectives/1.json
  def destroy
    status = PersonalObjective.delete_personal_objective(@personal_objective)
    respond_to do |format|
      if status == 200
        format.html { redirect_to '/', notice: 'Personal objective was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to '/', notice: 'Failed to destroy personal objective.' }
        format.json { head :no_content }
      end
    end
  end

  def details
    objective_id = params[:id]
    pages_initialization

    @personal_objective = PersonalObjective.find(objective_id)
    okr_team_personal = OkrTeamPersonal.find_by(personal_objective_id: objective_id)
    
    if okr_team_personal != nil
      @team_key_result = TeamKeyResult.find(okr_team_personal.team_key_result_id)
      @kr_user_info = User.find(@team_key_result.user_id)
      @okr_team_info = @team_key_result.team_objective
    else
      okr_company_personal = OkrCompanyPersonal.find_by(personal_objective_id: objective_id)
      @company_key_result = CompanyKeyResult.find(okr_company_personal.company_key_result_id)
      @kr_user_info = User.find(@company_key_result.user_id)
    end

    @kr_user_short_str = Shortform.get_string_shortform(@kr_user_info.first_name)
    

    @user_info = User.find(@personal_objective.user_id)
    @obj_user_short_str = Shortform.get_string_shortform(@user_info.first_name)

    @personal_key_results = PersonalKeyResult.where(personal_objective_id: objective_id)
    
    @timeframe_log = TimeframeLog.find(@personal_objective.timeframe_log_id)

    @log = LogPersonalObjective.where(personal_objective_id: objective_id).order(id: :DESC)

    render "app/personal_objective_details" 
  end

  def view_others_personal_okr
    pages_initialization

    user_id = params[:id]
    @other_user = User.find(user_id)     
    okr_user_role = OkrUserRole.find_by(user_id: @other_user.id)
    @other_user_role = OkrRole.find(okr_user_role.okr_role_id)
    @personal_objective = PersonalObjective.where(user_id: @other_user.id, timeframe_log_id: @selected_timeframe.id)
    @completed_objective = 0  

    if(@personal_objective.count != 0)  
      temp_date = [] 
      @total_progress = 0
      @personal_objective.each do |item| 
        @total_progress = @total_progress + item.progress 
        # To check whether there is any completed objective  
        if(item.progress == 100.00) 
          @completed_objective = @completed_objective + 1 
        end 
        # To check which is the latest updated date 
        temp_date << item.updated_at 
      end 
      @total_progress = @total_progress / @personal_objective.count
      date_max = temp_date.max 
      @date_difference = (Time.now - date_max) / 86400 
    end 

    render 'app/personal_okr_others'
  end

  def edit_objective
    objective_id = params[:id]
    edited_objective = params[:edited_objective]
    original_objective = params[:original_objective]

    status = PersonalObjective.rename_personal_objective(original_objective, edited_objective, objective_id, current_user.id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Personal Objective is updated successfully!', status: :ok }
      else
        format.json { render json: 'Failed to update personal objective!', status: :ok }
      end
    end       
  end

  def get_created_date 
    objective_id = params[:id]
    objective_created_date = PersonalObjective.retrieve_created_date(objective_id)

    respond_to do |format|
      format.json { render json: objective_created_date, status: :ok }
    end
  end

  def get_contribution
    objective_id = params[:id]
    contributions_log = LogPersonalObjective.retrieve_contribution(objective_id)

    respond_to do |format|
      format.json { render json: contributions_log, status: :ok }
    end
  end

  def search_objective
    keyword = params[:keyword]
    okr_user_timeframe = OkrUserTimeframe.find_by(user_id: current_user.id)
    result_objectives = PersonalObjective.search_objective(keyword, okr_user_timeframe.timeframe_log_id)
    respond_to do |format|
      format.json { render json: result_objectives, status: :ok }  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_objective
      @personal_objective = PersonalObjective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_objective_params
      params.require(:personal_objective).permit(:objective,:progress,:timeframe_log_id,:user_id);
    end

end
