class TeamObjectivesController < ApplicationController

  # GET /team_objectives/new
  def new
    @team_objective = TeamObjective.new
  end

  # GET /team_objectives/1/edit
  def edit
  end

  # POST /team_objectives
  # POST /team_objectives.json
  def create
    objective = params[:objective]
    company_key_result_id = params[:company_key_result_id]
    team_id = params[:team_id]

    status = TeamObjective.new_team_objective(objective, company_key_result_id, current_user.id, team_id)

    respond_to do |format|
      if status == 200       
        format.json { render json: 'Team Objective is created successfully!', status: :ok }
      else
        format.json { render json: 'Fail to create team objective!', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_objectives/1
  # PATCH/PUT /team_objectives/1.json
  def update
    respond_to do |format|
      if @team_objective.update(team_objective_params)
        update_okr_modules(@team_objective.id,@team_objective.progress)
        format.html { redirect_to @team_objective, notice: 'Team objective was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_objective }
      else
        format.html { render :edit }
        format.json { render json: @team_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_objectives/1
  # DELETE /team_objectives/1.json
  def destroy
    objective_id = params[:id]
    team_id = params[:okr_team_id]
    status = TeamObjective.delete_team_objective(objective_id)
    respond_to do |format|
      if status == 200
        format.html { redirect_to "/team/#{team_id}/team_objectives/team_dashboard/", 
                      notice: 'Team objective was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/team/#{team_id}/team_objectives/team_dashboard/", 
                      notice: 'Failed to destroy team objective' }
        format.json { head :no_content }
      end
    end
  end

  def team_dashboard
    pages_initialization

    @team_id = params[:okr_team_id]
    
    @okr_team = OkrTeam.find(@team_id)
    team_shortform = @okr_team.name.scan(/[A-Z]/) 
    @team_short_str = "" 
    team_shortform.each do |item| 
      @team_short_str = @team_short_str + item 
    end 

    # Find out the team lead 
    @team_users = OkrTeam.find_team_users_in_team(@team_id)
    @team_lead = "N/A"
    @team_users.each do |item|
      @okr_role = User.where(id: item.id).first.okr_role
      if(@okr_role.name == "Team Lead")
        @team_lead = item.last_name + " " + item.first_name
      end
    end 

    # Find out the users list which are not in the team
    @users_not_in_team = User.return_users_lists_not_in_team(@team_id, current_user.id)    

    @team_objective = TeamObjective.where(okr_team_id: @team_id, timeframe_log_id: @selected_timeframe.id).order(updated_at: :DESC)
    @completed_objective = 0 
    if(@team_objective.count != 0) 
      @progress_portion = 100 / @team_objective.count 
      @total_progress = 0 
      @temp_date = [] 
      @team_objective.each do |item| 
        @temp_progress = (item.progress/100) * @progress_portion 
        @total_progress = @total_progress + @temp_progress 
        # To check whether there is any completed objective  
        if(item.progress == 100.00) 
          @completed_objective = @completed_objective + 1 
        end 
        # To check which is the latest updated date 
        @temp_date << item.updated_at 
      end 
      @date_max = @temp_date.max 
      @date_difference = (Time.now - @date_max) / 86400 
    end

    # Create new team objective section
    @company_key_results = []
    company_objectives = CompanyObjective.where(timeframe_log_id: @selected_timeframe.id)
    if company_objectives.count != 0 
      company_objectives.each do |item|
        company_key_results = CompanyKeyResult.where(company_objective_id: item.id).map{|kr| [kr.key_result, kr.id]}
        company_key_results.each do |element|
          @company_key_results.push(element)
        end    
      end
    end

    render 'app/team_dashboard'
  end

  def details
    @objective_id = params[:id]
    @team_id = params[:okr_team_id]
    @okr_team = OkrTeam.find(@team_id)

    pages_initialization

    @okr_company_team = OkrCompanyTeam.find_by(team_objective_id: @objective_id)
    @company_key_result = CompanyKeyResult.find(@okr_company_team.company_key_result_id)
    @ckr_user_info = User.find(@company_key_result.user_id)
    @ckr_user_shortform = Shortform.get_string_shortform(@ckr_user_info.first_name)
    
    @team_objective = TeamObjective.find(@objective_id)
    @team_key_results = TeamKeyResult.where(team_objective_id: @objective_id)
    @log = LogTeamObjective.where(team_objective_id: @objective_id).order(id: :DESC)

    @user_info = User.find(@team_objective.user_id)
    @team_obj_user_shortform = Shortform.get_string_shortform(@user_info.first_name)

    @current_date = Time.now.strftime("%Y-%m-%d") 
    @timeframe_log = TimeframeLog.find(@team_objective.timeframe_log_id) 

    render 'app/team_objective_details'
  end

  def edit_objective
    objective_id = params[:id]
    edited_objective = params[:edited_objective]
    original_objective = params[:original_objective]

    status = TeamObjective.rename_team_objective(original_objective, edited_objective, objective_id, current_user.id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Team Objective is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update team objective!', status: :unprocessable_entity }
      end
    end
  end

  def get_created_date 
    objective_id = params[:id]
    objective_created_date = TeamObjective.retrieve_created_date(objective_id)

    respond_to do |format|
      format.json { render json: objective_created_date, status: :ok }
    end
  end

  def get_contribution
    objective_id = params[:id]
    contributions_log = LogTeamObjective.retrieve_contribution(objective_id)

    respond_to do |format|
      format.json { render json: contributions_log, status: :ok }
    end
  end

  def search_objective
    keyword = params[:keyword]
    okr_user_timeframe = OkrUserTimeframe.find_by(user_id: current_user.id)
    result_objectives = TeamObjective.search_objective(keyword, okr_user_timeframe.timeframe_log_id)
    respond_to do |format|
      format.json { render json: result_objectives, status: :ok }  
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_objective_params
      params.require(:team_objective).permit(:objective, :progress, :timeframe_log_id, :okr_team_id, :user_id);
    end
    
end
