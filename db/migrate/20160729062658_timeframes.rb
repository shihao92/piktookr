class Timeframes < ActiveRecord::Migration[5.0]
  def change
    create_table :timeframes do |t|
      t.integer      :year
      t.string       :timeframe_type
      t.timestamps
    end
  end
end
