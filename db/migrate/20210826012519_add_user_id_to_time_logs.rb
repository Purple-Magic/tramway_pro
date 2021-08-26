class AddUserIdToTimeLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :time_logs, :user_id, :integer
  end
end
