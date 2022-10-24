class AddDataToTimeLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :time_logs, :data, :jsonb
  end
end
