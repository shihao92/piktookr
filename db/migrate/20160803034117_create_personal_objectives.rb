class CreatePersonalObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :personal_objectives do |t|
      t.string        :objective
      t.decimal       :progress, :precision => 5, :scale => 2
      t.references    :timeframe_log, foreign_key: true
      t.references    :user, foreign_key: true
      t.timestamps
    end
  end
end
