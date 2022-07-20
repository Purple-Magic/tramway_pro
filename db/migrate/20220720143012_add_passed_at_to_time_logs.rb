class AddPassedAtToTimeLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :time_logs, :passed_at, :datetime
  end
end
