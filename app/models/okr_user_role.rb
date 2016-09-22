class OkrUserRole < ActiveRecord::Base

    # ---------
    # Relations
    # ---------

    belongs_to :user
    belongs_to :okr_role

    # -----------
    # Validations
    # -----------

    validates   :user_id, presence: true, :numericality => { only_integer: true }
    validates   :okr_role_id, presence: true, :numericality => { only_integer: true }    

end
