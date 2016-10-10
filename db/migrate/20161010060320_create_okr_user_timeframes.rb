class CreateOkrUserTimeframes < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_user_timeframes do |t|
      t.references  :user, foreign_key: true
      t.references  :timeframe_log, foreign_key: true
      t.timestamps
    end
  end
end
