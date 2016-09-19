class Contribution < ApplicationRecord

    belongs_to      :personal_key_result
    has_one         :log_personal_key_result

end
