# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Concentration < BotTelegram::FindMedsBot::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'concentrations'

  belongs_to :component, class: 'BotTelegram::FindMedsBot::Tables::Component', column: 'Действующее вещество'

  SHORT_NAMES = {
    vv: 'vial_volume',
    cig: 'mg_concentration', # concentration_in_grams
    csimpm: 'concentrated_solution_in_milligrams_per_milliliter'
  }.freeze

  UNITS = {
    cig: 'мг',
    vv: 'мл',
    csimpm: 'мг/мл'
  }.freeze

  def value
    if concentration_in_grams?
      "#{fields[SHORT_NAMES[:cig]]} #{UNITS[:cig]}"
    elsif concentrated_solution_in_milligrams_per_milliliter?
      "#{fields[SHORT_NAMES[:csimpm]]} #{UNITS[:csimpm]}, #{fields[SHORT_NAMES[:vv]]} #{UNITS[:vv]}"
    end
  end

  private

  def concentration_in_grams?
    fields[SHORT_NAMES[:cig]].present?
  end

  def concentrated_solution_in_milligrams_per_milliliter?
    fields[SHORT_NAMES[:vv]].present? && fields[SHORT_NAMES[:csimpm]].present?
  end
end
