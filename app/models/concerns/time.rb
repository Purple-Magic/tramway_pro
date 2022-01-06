# :reek:UtilityFunction { enabled: false } 
module Concerns::Time
  def time_view_by(all_minutes)
    minutes = all_minutes % 60
    hours = all_minutes / 60
    "#{hours}h #{minutes}m"
  end
end
# :reek:UtilityFunction { enabled: true } 
