# frozen_string_literal: true

class FindMeds::Tables::Drug < FindMeds::Tables::FindMedsBaseTable
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']
  self.table_name = 'drugs'

  def medicines
    ::FindMeds::Tables::Medicine.where('Drug' => [id])
  end
end
