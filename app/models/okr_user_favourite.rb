class OkrUserFavourite < ApplicationRecord

  # ---------
  # Relations
  # ---------

  belongs_to    :user
  belongs_to    :favourite, class_name: "User", foreign_key: "favourite_id"

  # -----------
  # Validations
  # -----------

  validates     :user_id, presence: true
  validates     :favourite_id, presence: true


  def self.insert_favourite_list(user_id, favourite_id)
    status = 0
    if OkrUserFavourite.create!(user_id: user_id, favourite_id: favourite_id)
      status = 200
    end

    return status
  end

  def self.remove_favourite_id(okr_user_fav_id)
    status = 0
    if OkrUserFavourite.find(okr_user_fav_id).destroy
      status = 200
    end

    return status
  end
  
end
