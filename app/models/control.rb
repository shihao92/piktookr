class Control < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :control_type
    has_many        :okr_role, :through => :okr_role_controls

    # -----------
    # Validations
    # -----------

    validates   :details, presence: true
    validates   :control_type_id, presence: true

end
