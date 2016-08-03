class CreateCompanyObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :company_objectives do |t|
      t.string      :objective
      t.decimal     :progress, :precision => 2, :scale => 2
      t.references  :timeframe_log, foreign_key: true
      t.timestamps
    end
  end
end
