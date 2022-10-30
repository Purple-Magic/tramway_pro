# frozen_string_literal: true

class FindMeds::Tables::Medicine < FindMeds::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'medicines'

  belongs_to :drug, class: 'FindMeds::Tables::Drug', column: 'Drug'

  def company
    FindMeds::Tables::Company.find link_to_company.first
  end

  def concentrations
    FindMeds::Tables::Concentration.where 'id' => concentrations
  end

  def separable_dosage?
    ['separable_dosage']&.include? 'можно делить'
  end

  def form
    fields['form']&.first
  end
end
