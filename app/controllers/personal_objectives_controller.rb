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
    @log = current_timeframe_log_id;
    @personal_objective = PersonalObjective.new(personal_objective_params.merge(progress: 0.0,timeframe_log_id: @log[0].id, user_id: current_user.id))
    respond_to do |format|
      if @personal_objective.save
        OkrTeamPersonal.create!(team_key_result_id: params[:team_key_result][:id], personal_objective_id: @personal_objective.id)
        format.html { redirect_to @personal_objective, notice: 'Personal objective was successfully created.' }
        format.json { render :show, status: :created, location: @personal_objective }
      else
        format.html { render :new }
        format.json { render json: @personal_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_objectives/1
  # PATCH/PUT /personal_objectives/1.json
  def update
    respond_to do |format|
      if @personal_objective.update(personal_objective_params)
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
    @personal_objective.destroy
    respond_to do |format|
      format.html { redirect_to personal_objectives_url, notice: 'Personal objective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_team_key_results
    @team_objective_id = params[:id]
    @team_key_results = TeamKeyResult.where(team_objective_id: @team_objective_id)
    render json: @team_key_results, status: :ok
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

    # Obtain the current timeframe log id based on the current date
    def current_timeframe_log_id
      @current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      @log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + @current_date + "'::DATE, '" + @current_date + "'::DATE)");
      return @log;
    end
end
