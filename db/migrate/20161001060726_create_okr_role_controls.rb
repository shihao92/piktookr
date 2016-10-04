class CreateOkrRoleControls < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_role_controls do |t|
      t.references    :okr_role, foreign_key: true
      t.references    :control, foreign_key: true
      t.timestamps
    end
  end
end
