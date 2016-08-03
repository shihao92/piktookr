class Team < ApplicationRecord

    has_many :okr_user_teams
    has_many :users, :through => :okr_user_teams

end
