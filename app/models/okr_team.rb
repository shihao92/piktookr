class OkrTeam < ApplicationRecord

    # ---------
    # Relations
    # ---------

    has_many    :okr_user_teams
    has_many    :users, :through => :okr_user_teams
    has_many    :team_objectives

    # -----------
    # Validations
    # -----------

    validates   :name, presence: true, length: { minimum: 2 }

    def self.find_team_users_in_team(team_id)
      @team_users = OkrTeam.where(id: team_id).first.users
      return @team_users    
    end

    def self.remove_team_from_system(team_id)
      status = 0
      if OkrTeam.find(team_id).destroy
        status = 200
      end

      return status
    end

end
