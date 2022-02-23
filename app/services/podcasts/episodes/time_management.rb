# frozen_string_literal: true

module Podcasts::Episodes::TimeManagement
  def change_time(time, direction = nil, difference = nil)
    converted_time = time_convert time
    case direction
    when :minus
      if converted_time > DateTime.new(2020, 1, 1, 0, 0, 0) + difference
        (converted_time - difference).strftime '%H:%M:%S'
      else
        ''
      end
    when :plus
      (converted_time + difference).strftime '%H:%M:%S'
    when nil
      converted_time.strftime '%H:%M:%S'
    end
  end

  def time_less_than(time, comparing_time)
    converted_time = time_convert time
    comparing_converted_time = time_convert comparing_time
    converted_time < comparing_converted_time
  end

  def time_convert(time)
    times = time.split(':')
    hour, minutes, seconds = times.count == 2 ? [0, *times] : times
    DateTime.new(2020, 0o1, 0o1, hour.to_i, minutes.to_i, seconds.to_i)
  end
end
