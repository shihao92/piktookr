class TeamKeyResult < ApplicationRecord

    belongs_to      :team_objective
    belongs_to      :user

    has_many        :okr_team_personals
    has_many        :personal_objectives, :through => :okr_team_personals

    has_many        :log_team_key_results

end
