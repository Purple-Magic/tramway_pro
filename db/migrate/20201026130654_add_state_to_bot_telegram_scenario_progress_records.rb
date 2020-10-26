class AddStateToBotTelegramScenarioProgressRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_scenario_progress_records, :state, :text
  end
end
