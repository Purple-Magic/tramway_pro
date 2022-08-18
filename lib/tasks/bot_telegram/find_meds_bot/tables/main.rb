# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Main < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'main'

  def separable_dosage?
    ['separable_dosage']&.include? 'можно делить'
  end
end
