# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Drug < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'drugs'
end
