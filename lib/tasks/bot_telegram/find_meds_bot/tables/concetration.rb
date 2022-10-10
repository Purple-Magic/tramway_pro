# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::Concentration < BotTelegram::FindMedsBot::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'concentrations'

  belongs_to :component, class: 'BotTelegram::FindMedsBot::Tables::Component', column: 'Действующее вещество'

  CONCENTRATION_IN_GRAM = 'mg_concentration'
  VIAL_VOLUME = 'vial_volume'
  CONCENTRATED_SOLUTION_IN_MILLIGRAMS_PER_MILLILITER = 'concentrated_solution_in_milligrams_per_milliliter'

  UNITS = {
    CONCENTRATION_IN_GRAM => 'мг',
    VIAL_VOLUME => 'мл',
    CONCENTRATED_SOLUTION_IN_MILLIGRAMS_PER_MILLILITER => 'мг/мл'
  }.freeze

  def value
    if concentration_in_grams?
      "#{fields[CONCENTRATION_IN_GRAM]} #{UNITS[CONCENTRATION_IN_GRAM]}"
    elsif concentrated_solution_in_milligrams_per_milliliter?
      "#{fields[CONCENTRATED_SOLUTION_IN_MILLIGRAMS_PER_MILLILITER]} #{UNITS[CONCENTRATED_SOLUTION_IN_MILLIGRAMS_PER_MILLILITER]}, #{fields[VIAL_VOLUME]} #{UNITS[VIAL_VOLUME]}"
    end
  end

  private

  def concentration_in_grams?
    fields[CONCENTRATION_IN_GRAM].present?
  end

  def concentrated_solution_in_milligrams_per_milliliter?
    fields[VIAL_VOLUME].present? && fields[CONCENTRATED_SOLUTION_IN_MILLIGRAMS_PER_MILLILITER].present?
  end
end
