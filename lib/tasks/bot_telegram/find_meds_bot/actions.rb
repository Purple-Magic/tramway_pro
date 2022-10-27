module BotTelegram::FindMedsBot::Actions
  include ::BotTelegram::FindMedsBot::Actions::FindMedicine
  include ::BotTelegram::FindMedsBot::Actions::ChooseCompany
  include ::BotTelegram::FindMedsBot::Actions::ChooseForm
  include ::BotTelegram::FindMedsBot::Actions::ChooseConcentration
  include ::BotTelegram::FindMedsBot::Actions::Reinforcement
  include ::BotTelegram::FindMedsBot::Actions::LastStep
end
