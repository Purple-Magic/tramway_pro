class Television::ScheduleItem < ApplicationRecord
  enumerize :schedule_type, in: [ 'order', 'time' ]
end
