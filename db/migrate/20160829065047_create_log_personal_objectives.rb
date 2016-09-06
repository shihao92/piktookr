class CreateLogPersonalObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :log_personal_objectives do |t|
      t.string      :log_content
      t.references  :personal_objective, foreign_key: true
      t.references  :user, foreign_key: true
      t.timestamps
    end
  end
end
