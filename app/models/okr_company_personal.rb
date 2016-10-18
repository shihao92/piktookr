class OkrCompanyPersonal < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to  :company_key_result
    belongs_to  :personal_objective

    # -----------
    # Validations
    # -----------

    validates   :company_key_result_id, presence: true
    validates   :personal_objective_id, presence: true


end
