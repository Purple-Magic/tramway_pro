class AddProjectIdToBotTelegramScenarioProgressRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_scenario_progress_records, :project_id, :integer
  end
end
