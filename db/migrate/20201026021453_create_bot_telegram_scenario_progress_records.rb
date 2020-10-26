class CreateBotTelegramScenarioProgressRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_scenario_progress_records do |t|
      t.integer :bot_telegram_user_id
      t.integer :bot_telegram_scenario_step_id
      t.text :answer

      t.timestamps
    end
  end
end
