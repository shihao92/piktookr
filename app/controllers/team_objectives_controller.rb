class TeamObjectivesController < ApplicationController
  before_action :set_team_objective, only: [:show, :edit, :update, :destroy]

  # GET /team_objectives
  # GET /team_objectives.json
  def index
    @team_objectives = TeamObjective.all
  end

  # GET /team_objectives/1
  # GET /team_objectives/1.json
  def show
  end

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
    @team_objective = TeamObjective.new(team_objective_params.merge(progress: 0.0))
    respond_to do |format|
      if @team_objective.save
        OkrCompanyTeam.create!(team_objective_id: @team_objective.id,company_key_result_id: params[:company_key_result][:kr_id])
        format.html { redirect_to @team_objective, notice: 'Team objective was successfully created.' }
        format.json { render :show, status: :created, location: @team_objective }
      else
        format.html { render :new }
        format.json { render json: @team_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_objectives/1
  # PATCH/PUT /team_objectives/1.json
  def update
    respond_to do |format|
      if @team_objective.update(team_objective_params)
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
    OkrCompanyTeam.where(team_objective_id: @team_objective.id).destroy_all
    @team_objective.destroy
    respond_to do |format|
      format.html { redirect_to team_objectives_url, notice: 'Team objective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_objective
      @team_objective = TeamObjective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_objective_params
      @log = current_timeframe_log_id;
      params.require(:team_objective).permit(:objective,:progress,:timeframe_log_id,:okr_team_id).merge(timeframe_log_id: @log[0].id,okr_team_id: params[:team][:team_id]);
    end

    # Obtain the current timeframe log id based on the current date
    def current_timeframe_log_id
      @current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      @log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + @current_date + "'::DATE, '" + @current_date + "'::DATE)");
      return @log;
    end
end
