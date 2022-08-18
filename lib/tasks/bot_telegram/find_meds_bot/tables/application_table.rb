# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::ApplicationTable < Airrecord::Table
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']

  class << self
    def find_by(**options)
      where(**options).first
    end

    def where(**options)
      all.select do |medicine|
        options.map do |(key, value)|
          medicine[key] == value
        end.uniq == [true]
      end
    end

    def first
      all.first
    end
  end
end
