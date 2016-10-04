class CreateControls < ActiveRecord::Migration[5.0]
  def change
    create_table :controls do |t|
      t.string      :details
      t.references  :control_type, foreign_key: true
      t.timestamps
    end
  end
end
