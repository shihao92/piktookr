class OkrTeamsController < ApplicationController
  before_action :set_okr_team, only: [:show, :edit, :update, :destroy]

  # GET /okr_teams
  # GET /okr_teams.json
  def index
    @okr_teams = OkrTeam.all
  end

  # GET /okr_teams/1
  # GET /okr_teams/1.json
  def show
  end

  # GET /okr_teams/new
  def new
    @users = User.all
    @okr_team = OkrTeam.new
  end

  # GET /okr_teams/1/edit
  def edit
  end

  # POST /okr_teams
  # POST /okr_teams.json
  def create
    @okr_team = OkrTeam.new(okr_team_params)

    respond_to do |format|
      if @okr_team.save
        format.html { redirect_to @okr_team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @okr_team }
      else
        format.html { render :new }
        format.json { render json: @okr_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okr_teams/1
  # PATCH/PUT /okr_teams/1.json
  def update
    respond_to do |format|
      if @okr_team.update(okr_team_params)
        format.html { redirect_to @okr_team, notice: 'Okr team was successfully updated.' }
        format.json { render :show, status: :ok, location: @okr_team }
      else
        format.html { render :edit }
        format.json { render json: @okr_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okr_teams/1
  # DELETE /okr_teams/1.json
  def destroy
    @okr_team.destroy
    respond_to do |format|
      format.html { redirect_to okr_teams_url, notice: 'Okr team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_okr_team
      @okr_team = OkrTeam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def okr_team_params
      params.require(:okr_team).permit(:name, :description)
    end
end
