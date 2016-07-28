class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string      :name,  null: false, default: ""
      t.string      :status
      t.timestamps
    end
  end
end
