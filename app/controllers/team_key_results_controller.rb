class TeamKeyResultsController < ApplicationController
  before_action :set_team_key_result, only: [:show, :edit, :update, :destroy]

  # GET /team_key_results
  # GET /team_key_results.json
  def index
    @team_key_results = TeamKeyResult.all
  end

  # GET /team_key_results/1
  # GET /team_key_results/1.json
  def show
  end

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
    @team_key_result = TeamKeyResult.new(team_key_result_params.merge(progress: 0.0))
    
    respond_to do |format|
      if @team_key_result.save
        format.html { redirect_to @team_key_result, notice: 'Team key result was successfully created.' }
        format.json { render :show, status: :created, location: @team_key_result }
      else
        format.html { render :new }
        format.json { render json: @team_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_key_results/1
  # PATCH/PUT /team_key_results/1.json
  def update
    respond_to do |format|
      if @team_key_result.update(team_key_result_params)
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
    @team_key_result.destroy
    respond_to do |format|
      format.html { redirect_to team_key_results_url, notice: 'Team key result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # At team key result, obtain the team id and populate team objectives in the dropdown
  def get_team_objective
    @okr_team_id = params[:id]
    @team_objectives = TeamObjective.where(okr_team_id:@okr_team_id) 
    render json: @team_objectives, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_key_result
      @team_key_result = TeamKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_key_result_params
      params.require(:team_key_result).permit(:key_result,:progress,:team_objective_id).merge(team_objective_id: params[:team_objective][:id]);
    end
end
