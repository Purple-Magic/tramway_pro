# frozen_string_literal: true

class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :wrong_time_format) unless value.match?(/\d[hms]+/)
  end
end
