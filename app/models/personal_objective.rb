class PersonalObjective < ApplicationRecord

    has_many           :okr_team_personals
    has_many           :team_key_results, :through => :okr_team_personals
    belongs_to         :timeframe_log
    belongs_to         :user

    has_many           :personal_key_results

    has_many           :log_personal_objectives

end
