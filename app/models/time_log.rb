# frozen_string_literal: true

class TimeLog < ApplicationRecord
  belongs_to :associated, polymorphic: true
  belongs_to :user, class_name: 'Tramway::User::User'

  enumerize :associated_type, in: [ Courses::Video ]

  scope :logged_by, -> (user, associated) do
    minutes = associated.time_logs.where(user_id: user).sum do |time_log|
      time_log.minutes
    end
    "#{minutes / 60}h #{minutes % 60}m"
  end

  def minutes
    time_spent.split(' ').reduce(0) do |sum, part|
      number = part.match(/[0-9]*/)
      case part[-1]
      when 'h'
        sum += number * 60
      when 'm'
        sum += number
      end
    end
  end
end
