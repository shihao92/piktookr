class OkrTeamsController < ApplicationController
  before_action :set_okr_team, only: [:show, :edit, :update, :destroy]

  # GET /okr_teams
  # GET /okr_teams.json
  def index
    @okr_teams = OkrTeam.all

    render 'app/system_teams'
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
    team_name = params[:name]
    description = params[:description]

    @okr_team = OkrTeam.new(name: team_name, description: description)

    respond_to do |format|
      if @okr_team.save
        format.json { render json: 'Team is created successfully!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okr_teams/1
  # PATCH/PUT /okr_teams/1.json
  def update
    team_name = params[:name]
    team_description = params[:description]
    team_id = params[:id]

    respond_to do |format|
      if OkrTeam.where(id: team_id).update_all(name: team_name, description: team_description)
        format.json { render json: 'Team is updated successfully!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okr_teams/1
  # DELETE /okr_teams/1.json
  def destroy
    team_id = params[:id]
    status = OkrTeam.remove_team_from_system(team_id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Team is removed successfully from the system!', status: :ok }
      else
        format.json { render json: 'Unable to remove team from system!', status: :unprocessable_entity }
      end
    end
  end

  def remove_user_from_team
    okr_user_team_id = params[:id]
    status = OkrUserTeam.remove_user_from_team(okr_user_team_id)
    respond_to do |format|
      if status == 200
        format.json { render json: 'User is removed from team!', status: :ok }
      else
        format.json { render json: 'Unable to remove user from team!', status: :unprocessable_entity }
      end
    end
  end

  def get_team_info
    team_id = params[:id]
    team_info = OkrTeam.find(team_id)
    respond_to do |format|
      if status == 200
        format.json { render json: team_info, status: :ok }
      else
        format.json { render json: 'Unable to get team information!', status: :unprocessable_entity }
      end
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
