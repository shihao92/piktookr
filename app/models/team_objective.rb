class TeamObjective < ApplicationRecord

    has_many           :okr_company_teams
    has_many           :company_key_results, :through => :okr_company_teams
    belongs_to         :okr_team
    has_many           :team_key_results
    belongs_to         :timeframe_log


    has_many           :log_team_objectives

end
