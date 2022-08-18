# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Medicine < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'names'
end
