class CreateOkrTeamPersonals < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_team_personals do |t|
      t.references    :team_key_result, foreign_key: true
      t.references    :personal_objective, foreign_key: true
      t.timestamps
    end
  end
end
