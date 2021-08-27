# frozen_string_literal: true

class TimeLog < ApplicationRecord
  belongs_to :associated, polymorphic: true
  belongs_to :user, class_name: 'Tramway::User::User'

  enumerize :associated_type, in: [Courses::Video]

  scope :logged_by, lambda { |user, associated|
    minutes = associated.time_logs.where(user_id: user).sum(&:minutes)
    "#{minutes / 60}h #{minutes % 60}m"
  }

  def minutes
    time_spent.split.reduce(0) do |sum, part|
      number = part.match(/[0-9]*/).to_s.to_i
      case part[-1]
      when 'h'
        sum += number * 60
      when 'm'
        sum += number
      end
    end
  end
end
