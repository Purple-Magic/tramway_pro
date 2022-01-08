FactoryBot.define do
  factory :bot_telegram_scenario_process_record, class: 'BotTelegram::Scenario::ProgressRecord' do
    user { create :bot_telegram_user }
    step { create :bot_telegram_scenario_step }
    project_id { Project.find_by(title: 'RedMagic').id }
  end
end
