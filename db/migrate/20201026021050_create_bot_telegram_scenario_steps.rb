class CreateBotTelegramScenarioSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_scenario_steps do |t|
      t.text :name
      t.text :text
      t.jsonb :reply_markup
      t.jsonb :options

      t.timestamps
    end
  end
end
