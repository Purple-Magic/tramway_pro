# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Medicine < BotTelegram::FindMedsBot::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'medicines'

  belongs_to :drug, class: 'BotTelegram::FindMedsBot::Tables::Drug', column: 'Drug'

  def company
    BotTelegram::FindMedsBot::Tables::Company.find link_to_company.first
  end

  def concentrations
    BotTelegram::FindMedsBot::Tables::Concentration.where 'id' => concentrations
  end

  def separable_dosage?
    ['separable_dosage']&.include? 'можно делить'
  end

  def form
    fields['form']&.first
  end
end
