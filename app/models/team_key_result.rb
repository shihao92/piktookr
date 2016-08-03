class TeamKeyResult < ApplicationRecord

    belongs_to      :team_objective

    has_many        :okr_team_personals
    has_many        :personal_objectives, :through => :okr_team_personals

end
