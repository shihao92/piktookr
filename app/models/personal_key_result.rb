class PersonalKeyResult < ApplicationRecord

    belongs_to      :personal_objective
    has_one         :contribution

end
