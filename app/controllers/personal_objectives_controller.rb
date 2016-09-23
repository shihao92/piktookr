class PersonalObjectivesController < ApplicationController
  before_action :set_personal_objective, only: [:show, :edit, :update, :destroy]

  # GET /personal_objectives
  # GET /personal_objectives.json
  def index
    @personal_objectives = PersonalObjective.all
  end

  # GET /personal_objectives/1
  # GET /personal_objectives/1.json
  def show
  end

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
        format.json { render json: 'Failed to create personal objective!', status: :ok }
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

    @personal_objective = PersonalObjective.find(objective_id)
    okr_team_personal = OkrTeamPersonal.find_by(personal_objective_id: objective_id)
    @team_key_result = TeamKeyResult.find(okr_team_personal.team_key_result_id)
    @personal_key_results = PersonalKeyResult.where(personal_objective_id: objective_id)
 
    @remaining_quarter_days = Timeframe.calculate_remaining_days_current_quarter

    @user_info = User.find(@personal_objective.user_id)
    @timeframe_log = TimeframeLog.find(@personal_objective.timeframe_log_id)

    @log = LogPersonalObjective.where(personal_objective_id: objective_id).order(id: :DESC)

    render "app/personal_objective_details" 
  end

  def view_others_personal_okr
    user_id = params[:id]
    @user = User.find(user_id)     
    okr_user_role = OkrUserRole.find_by(user_id: user_id)
    @role = OkrRole.find(okr_user_role.okr_role_id)    
    @personal_objective = PersonalObjective.where(user_id: user_id) 
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
    
    @remaining_quarter_days = Timeframe.calculate_remaining_days_current_quarter 

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
