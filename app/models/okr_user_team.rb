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

end
