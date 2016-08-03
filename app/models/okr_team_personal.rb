class OkrTeamPersonal < ApplicationRecord

    belongs_to      :personal_objective
    belongs_to      :team_key_result

end
