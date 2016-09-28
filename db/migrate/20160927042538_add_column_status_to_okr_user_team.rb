class AddColumnStatusToOkrUserTeam < ActiveRecord::Migration[5.0]
  def change
    add_column      :okr_user_teams, :status, :string
  end
end
