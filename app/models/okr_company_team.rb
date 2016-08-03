class OkrCompanyTeam < ApplicationRecord

    belongs_to  :company_key_result
    belongs_to  :team_objective

end
