module TimeManager
  def minutes_of(value)
    return 0 unless value.present?

    value.split.reduce(0) do |sum, part|
      number = part.match(/[0-9]*/).to_s.to_i
      case part[-1]
      when 'h'
        sum + number * 60
      when 'm'
        sum + number
      end
    end || 0
  end

  def minutes_to_hours(minutes)
    "#{minutes / 60}h #{minutes % 60}m"
  end
end
