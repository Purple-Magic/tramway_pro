# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Concentration < BotTelegram::FindMedsBot::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'concentrations'

  belongs_to :component, class: 'BotTelegram::FindMedsBot::Tables::Component', column: "Действующее вещество"
  
  CONCENTRATION_IN_GRAM = 'mg_concentration'

  UNITS = {
    CONCENTRATION_IN_GRAM => 'мг'
  }

  def value
    if concentration_in_grams?
      "#{fields[CONCENTRATION_IN_GRAM]} #{UNITS[CONCENTRATION_IN_GRAM]}"
    end
  end

  private

  def concentration_in_grams?
    fields[CONCENTRATION_IN_GRAM].present?
  end
end
