# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Medicine < BotTelegram::FindMedsBot::Tables::ApplicationTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'medicines'

  belongs_to :company, class: 'BotTelegram::FindMedsBot::Tables::Company', column: 'Company'

  def drug
    BotTelegram::FindMedsBot::Tables::Drug.find fields['Drug'].first
  end

  def concentrations
    fields['concentrations'].map do |concentration_id|
      BotTelegram::FindMedsBot::Tables::Concentration.find concentration_id
    end
  end

  def separable_dosage?
    ['separable_dosage']&.include? 'можно делить'
  end

  def form
    fields['form']&.first
  end

  def name
    fields['Name']
  end
end
