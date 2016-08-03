class TimeframeLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :timeframe_logs do |t|
      t.date        :start_date
      t.date        :end_date
      t.references  :timeframe, foreign_key: true
      t.timestamps
    end
  end
end
