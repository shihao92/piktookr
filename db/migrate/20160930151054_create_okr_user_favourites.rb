class CreateOkrUserFavourites < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_user_favourites do |t|
      t.references    :user, foreign_key: true
      t.references    :favourite, index: true
      t.timestamps
    end
  end
end
