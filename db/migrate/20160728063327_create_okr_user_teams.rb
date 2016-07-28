class CreateOkrUserTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_user_teams do |t|
      t.references :user, foreign_key: true
      t.references :okr_team, foreign_key: true
      t.timestamps
    end
  end
end
