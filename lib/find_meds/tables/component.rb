# frozen_string_literal: true

class FindMeds::Tables::Component < FindMeds::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'components'

  has_many :concentrations, class: 'FindMeds::Tables::Concentration', column: 'Действующее вещество'
end
