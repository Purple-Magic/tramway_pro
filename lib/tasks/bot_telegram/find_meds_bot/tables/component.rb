# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Component < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'active_components'

  has_many :concentrations, class: 'BotTelegram::FindMedsBot::Tables::Concentration', column: "Действующее вещество"

  def medicines_with_single_component
    @medicines_with_single_component ||= BotTelegram::FindMedsBot::Tables::Medicine.where 'components' => [id]
  end
end
