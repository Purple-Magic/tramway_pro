module Podcasts::Episodes::TimeManagement
  def change_time(time, direction, difference)
    times = time.split(':')
    hour, minutes, seconds = times.count == 2 ? [0, *times] : times
    converted_time = DateTime.new(2020, 0o1, 0o1, hour.to_i, minutes.to_i, seconds.to_i)
    case direction
    when :minus
      if converted_time > DateTime.new(2020, 1, 1, 0, 0, 0) + difference
        (converted_time - difference).strftime '%H:%M:%S'
      else
        ''
      end
    when :plus
      (converted_time + difference).strftime '%H:%M:%S'
    end
  end
end 
