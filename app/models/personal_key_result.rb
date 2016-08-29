class PersonalKeyResult < ApplicationRecord

    belongs_to      :personal_objective
    has_many        :contributions
    accepts_nested_attributes_for :contributions

end
