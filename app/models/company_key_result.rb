class CompanyKeyResult < ApplicationRecord

    belongs_to   :company_objective
    has_many     :okr_company_teams
    has_many     :team_objectives, :through => :okr_company_teams

    has_many     :log_company_key_results

end
