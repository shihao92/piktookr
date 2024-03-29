# Date : 5 August 2016
# Completed module : Create, Read and Update feature for OKR Module
# To be completed module : Delete OKR

class TeamKeyResultsController < ApplicationController
  before_action :set_team_key_result, only: [:edit, :update, :destroy]

  # GET /team_key_results/new
  def new
    @team_key_result = TeamKeyResult.new
  end

  # GET /team_key_results/1/edit
  def edit
  end

  # POST /team_key_results
  # POST /team_key_results.json
  def create
    key_result = params[:key_result]
    team_objective_id = params[:team_objective_id]

    status = TeamKeyResult.new_team_key_result(key_result, team_objective_id, current_user.id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Team Key Result is created successfully!', status: :ok }
      else
        format.json { render json: 'Team Key Result must have more than 5 characters!', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_key_results/1
  # PATCH/PUT /team_key_results/1.json
  def update
    respond_to do |format|
      if @team_key_result.update(team_key_result_params)
        update_okr_modules(@team_key_result.team_objective_id, @team_key_result.id, @team_key_result.progress)
        format.html { redirect_to @team_key_result, notice: 'Team key result was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_key_result }
      else
        format.html { render :edit }
        format.json { render json: @team_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_key_results/1
  # DELETE /team_key_results/1.json
  def destroy
    team_id = params[:okr_team_id]
    team_objective = TeamObjective.find(@team_key_result.team_objective_id)
    okr_team_personal = OkrTeamPersonal.find_by(team_key_result_id: @team_key_result.id)
    if okr_team_personal == nil
      status = TeamKeyResult.delete_team_key_result(@team_key_result)
    else 
      status = 202
    end
    respond_to do |format|
      if status == 200
        format.html { redirect_to "/team/#{team_id}/team_objectives/team_dashboard/", 
                      notice: 'Team key result was successfully destroyed.' }
        format.json { head :no_content }
      elsif status == 202
        format.html { redirect_to "/team/#{team_id}/team_objectives/team_dashboard/", 
                      notice: 'Failed to destroy team key result.' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/team/#{team_id}/team_objectives/team_dashboard/", 
                      notice: 'Failed to destroy team key result.' }
        format.json { head :no_content }
      end
    end
  end

  def details
    @key_result_id = params[:id]
    @team_id = params[:okr_team_id]

    pages_initialization

    @okr_team = OkrTeam.find(@team_id)
    @team_key_result = TeamKeyResult.find(@key_result_id)
    @team_objective = TeamObjective.find(@team_key_result.team_objective_id)
    @obj_user_info = User.find(@team_objective.user_id)
    @obj_user_short_str = Shortform.get_string_shortform(@obj_user_info.first_name)

    @user_info = User.find(@team_key_result.user_id)

    @log = LogTeamKeyResult.where(team_key_result_id: @key_result_id).order(id: :DESC)
    @timeframe_log = TimeframeLog.find(@team_objective.timeframe_log_id)
    if @team_key_result.due_date != nil
      if @timeframe_log.end_date == @team_key_result.due_date
        @timeframe_day_difference = @remaining_quarter_days.to_i
      else
        @timeframe_day_difference = @team_key_result.due_date - Date.today
        if @timeframe_day_difference < 0 
          @timeframe_day_difference = 0
        end
      end
    else
      @timeframe_day_difference = @remaining_quarter_days.to_i
    end

    @temp_personal_objective = []
    okr_team_personals = OkrTeamPersonal.where(team_key_result_id: @key_result_id)
    okr_team_personals.each do |item|
      @personal_objective = PersonalObjective.where(id: item.personal_objective_id).map{|obj| [obj.id, obj.objective, obj.user_id]}
      @temp_personal_objective.push(@personal_objective)
    end

    render 'app/team_key_result_details'
  end

  def edit_key_result
    key_result_id = params[:id]
    edited_key_result = params[:edited_key_result]
    original_key_result = params[:original_key_result]

    status = TeamKeyResult.rename_team_key_result(original_key_result, edited_key_result, key_result_id, current_user.id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Team Key Result is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update team key result!', status: :unprocessable_entity }
      end
    end
  end

  def insert_due_date
    key_result_id = params[:id]
    selected_due_date = params[:due_date]
    status = TeamKeyResult.update_due_date(key_result_id, selected_due_date)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Due date is created successfully!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  def get_created_date
    key_result_id = params[:id]
    kr_created_date = TeamKeyResult.retrieve_created_date(key_result_id)
    respond_to do |format|
      format.json { render json: kr_created_date, status: :ok }
    end
  end

  def get_contribution
    key_result_id = params[:id]
    contributions_log = LogTeamKeyResult.retrieve_contribution(key_result_id)

    respond_to do |format|
      format.json { render json: contributions_log, status: :ok }
    end
  end

  def search_key_result
    keyword = params[:keyword]
    okr_user_timeframe = OkrUserTimeframe.find_by(user_id: current_user.id)
    result_key_results = TeamKeyResult.search_key_result(keyword, okr_user_timeframe.timeframe_log_id)
    respond_to do |format|
      format.json { render json: result_key_results, status: :ok }  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_key_result
      @team_key_result = TeamKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_key_result_params
      params.require(:team_key_result).permit(:key_result,:progress,:team_objective_id);
    end

end
