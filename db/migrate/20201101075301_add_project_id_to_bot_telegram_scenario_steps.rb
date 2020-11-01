class AddProjectIdToBotTelegramScenarioSteps < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_scenario_steps, :project_id, :integer
  end
end
