class OkrTeamPersonal < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :personal_objective
    belongs_to      :team_key_result

    # -----------
    # Validations
    # -----------

    validates   :team_key_result_id, presence: true, :numericality => { only_integer: true }
    validates   :personal_objective_id, presence: true, :numericality => { only_integer: true }

end
