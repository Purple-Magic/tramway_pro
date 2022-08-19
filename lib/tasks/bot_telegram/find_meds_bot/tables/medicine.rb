# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Medicine < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'medicines'

  belongs_to :drug, class: 'BotTelegram::FindMedsBot::Tables::Drug', column: 'Drug'
  belongs_to :company, class: 'BotTelegram::FindMedsBot::Tables::Company', column: 'Company'

  def separable_dosage?
    ['separable_dosage']&.include? 'можно делить'
  end
end
