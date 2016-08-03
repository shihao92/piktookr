class CreateOkrCompanyTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_company_teams do |t|
      t.references  :company_key_result, foreign_key: true
      t.references  :team_objective, foreign_key: true
      t.timestamps
    end
  end
end
