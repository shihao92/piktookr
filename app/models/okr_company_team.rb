class OkrCompanyTeam < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to  :company_key_result
    belongs_to  :team_objective

    # -----------
    # Validations
    # -----------

    validates   :company_key_result_id, presence: true
    validates   :team_objective_id, presence: true


end
