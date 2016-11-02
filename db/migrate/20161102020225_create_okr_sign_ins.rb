class CreateOkrSignIns < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_sign_ins do |t|
      t.references  :user, foreign_key: true
      t.integer     :sign_in_count
      t.timestamps
    end
  end
end
