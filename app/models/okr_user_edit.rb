class OkrUserEdit < ApplicationRecord

  # -----------
  # Validations
  # -----------

  validates   :user_id, presence: true, :numericality => { only_integer: true }
  validates   :editing_user_id, presence: true, :numericality => { only_integer: true }

end
