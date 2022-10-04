# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::ApplicationTable < Airrecord::Table
  self.base_key = ENV['FIND_MEDS_MAIN_BASE']

  def method_missing(method_name, *args)
    if fields.keys.include?(method_name.to_s)
      fields[method_name.to_s]
    else
      message = "You called #{method_name} with #{args}. This method doesn't exist."
      raise NoMethodError, message
    end
  end

  class << self
    def find_by(**options)
      where(**options).first
    end

    def where(**options)
      all.select do |object|
        options.map do |(key, value)|
          if key == 'id'
            if value.is_a? Array
              value.include? object.id
            else
              object.id == value
            end
          else
            object[key] == value
          end
        end.uniq == [true]
      end
    end

    def first
      all.first
    end
  end
end
