# frozen_string_literal: true

class FindMeds::Tables::Company < FindMeds::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'companies'

  has_many :medicines, class: 'FindMeds::Tables::Medicine', column: 'company'
end
