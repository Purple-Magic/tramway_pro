# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Concentration < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'concentrations'

  belongs_to :component, class: 'BotTelegram::FindMedsBot::Tables::Component', column: "Действующее вещество"

  def to_s
    fields.map do |(key, value)|
      next if key.in? ['Фирма, вещества, форма', 'Действующее вещество', 'Name']

      "#{key}: #{value}"
    end.join(',')
  end
end
