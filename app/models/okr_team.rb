class OkrTeam < ApplicationRecord

    has_many    :okr_user_teams
    has_many    :users, :through => :okr_user_teams
    has_many    :team_objectives

    def self.find_team_users_in_team(team_id)
      @team_users = OkrTeam.where(id: team_id).first.users
      return @team_users    
    end

end
