class OkrUserTeam < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to :user
    belongs_to :okr_team

    # -----------
    # Validations
    # -----------

    validates   :user_id, presence: true, :numericality => { only_integer: true }
    validates   :okr_team_id, presence: true, :numericality => { only_integer: true }

    def self.remove_user_from_team(okr_user_team_id)
      status = 0
      puts okr_user_team_id
      if OkrUserTeam.find(okr_user_team_id).destroy
        status = 200
      end

      return status
    end

end
