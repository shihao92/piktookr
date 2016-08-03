class PersonalObjective < ApplicationRecord

    has_many           :okr_team_personals
    has_many           :team_key_results, :through => :okr_team_personals
    belongs_to         :timeframe_log

    has_many           :personal_key_results

end
