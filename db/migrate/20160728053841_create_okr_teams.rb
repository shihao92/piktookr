class CreateOkrTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_teams do |t|
      t.string      :name,  null: false, default: ""
      t.string      :description
      t.timestamps
    end
  end
end
