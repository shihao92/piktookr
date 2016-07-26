class CreateOkrUserRole < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_user_roles do |t|
      t.references :user, foreign_key: true
      t.references :okr_role, foreign_key: true
    end
  end
end
