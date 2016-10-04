class OkrRoleControl < ApplicationRecord

  # ---------
  # Relations
  # ---------

  belongs_to      :control
  belongs_to      :okr_role

  # -----------
  # Validations
  # -----------

  validates   :okr_role_id, presence: true
  validates   :control_id, presence: true

end
