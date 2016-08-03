class OkrTeam < ApplicationRecord

    has_many    :users, :through => :okr_user_teams
    has_many   :team_objectives

end
