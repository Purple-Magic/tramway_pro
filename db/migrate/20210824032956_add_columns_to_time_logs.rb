class AddColumnsToTimeLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :time_logs, :state, :text
  end
end
