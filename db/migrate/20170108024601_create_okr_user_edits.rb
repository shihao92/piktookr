class CreateOkrUserEdits < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_user_edits do |t|
      t.integer     :user_id
      t.integer     :editing_user_id
      t.timestamps
    end
  end
end
