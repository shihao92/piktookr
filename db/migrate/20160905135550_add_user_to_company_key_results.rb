class AddUserToCompanyKeyResults < ActiveRecord::Migration[5.0]
  def change
    add_reference :company_key_results, :user, foreign_key: true
  end
end
