# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Concentration < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'concentrations'

  belongs_to :component, class: 'BotTelegram::FindMedsBot::Tables::Component', column: "Действующее вещество"
end