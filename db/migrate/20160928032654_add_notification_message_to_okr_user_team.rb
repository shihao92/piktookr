class AddNotificationMessageToOkrUserTeam < ActiveRecord::Migration[5.0]
  def change
    add_reference :okr_user_teams, :notification, foreign_key: true
  end
end
