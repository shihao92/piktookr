class OkrUserTeamsController < ApplicationController
  before_action :set_okr_user_team, only: [:show, :edit, :update, :destroy]

  # GET /okr_user_teams
  # GET /okr_user_teams.json
  def index
    @okr_user_teams = OkrUserTeam.all
  end

  # GET /okr_user_teams/1
  # GET /okr_user_teams/1.json
  def show
  end

  # GET /okr_user_teams/new
  def new
    @okr_user_team = OkrUserTeam.new
  end

  # GET /okr_user_teams/1/edit
  def edit
  end

  # POST /okr_user_teams
  # POST /okr_user_teams.json
  def create
    @okr_user_team = OkrUserTeam.new(okr_user_team_params)

    respond_to do |format|
      if @okr_user_team.save
        format.html { redirect_to @okr_user_team, notice: 'User joined the team successfully.' }
        format.json { render :show, status: :created, location: @okr_user_team }
      else
        format.html { render :new }
        format.json { render json: @okr_user_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okr_user_teams/1
  # PATCH/PUT /okr_user_teams/1.json
  def update
    respond_to do |format|
      if @okr_user_team.update(okr_user_team_params)
        format.html { redirect_to @okr_user_team, notice: 'User joined the team successfully.' }
        format.json { render :show, status: :ok, location: @okr_user_team }
      else
        format.html { render :edit }
        format.json { render json: @okr_user_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okr_user_teams/1
  # DELETE /okr_user_teams/1.json
  def destroy
    @okr_user_team.destroy
    respond_to do |format|
      format.html { redirect_to okr_user_teams_url, notice: 'User joined the team successfully.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_okr_user_team
      @okr_user_team = OkrUserTeam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def okr_user_team_params
      params.fetch(:okr_user_team, {})
    end
end
