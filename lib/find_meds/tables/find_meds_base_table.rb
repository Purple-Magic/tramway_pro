# frozen_string_literal: true

class FindMeds::Tables::FindMedsBaseTable < FindMeds::Tables::ApplicationTable
  def name
    self.Name
  end
end
