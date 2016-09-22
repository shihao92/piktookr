class Contribution < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :personal_key_result
    has_one         :log_personal_key_result

    # -----------
    # Validations
    # -----------

    validates   :contribution_comment, presence: true, length: { minimum: 5 }
    validates   :personal_key_result_id, presence: true, :numericality => { only_integer: true }
    validates   :log_personal_key_result_id, presence: true, :numericality => { only_integer: true }

end
