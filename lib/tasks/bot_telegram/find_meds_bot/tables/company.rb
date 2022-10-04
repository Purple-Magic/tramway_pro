# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Company < BotTelegram::FindMedsBot::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'companies'

  has_many :medicines, class: 'BotTelegram::FindMedsBot::Tables::Medicine', column: 'company'
end
