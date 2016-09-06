class PersonalKeyResult < ApplicationRecord

    belongs_to      :personal_objective
    has_many        :contributions
    accepts_nested_attributes_for :contributions

    has_many        :log_personal_key_results
    accepts_nested_attributes_for :log_personal_key_results

end
