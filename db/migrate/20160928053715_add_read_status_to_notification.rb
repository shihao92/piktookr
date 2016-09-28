class AddReadStatusToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column      :notifications, :read_status, :string
  end
end
