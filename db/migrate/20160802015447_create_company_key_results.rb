class CreateCompanyKeyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :company_key_results do |t|
      t.string      :key_result
      t.decimal     :progress, :precision => 5, :scale => 2
      t.references  :company_objective, foreign_key: true
      t.timestamps
    end
  end
end
