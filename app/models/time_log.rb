# frozen_string_literal: true

class TimeLog < ApplicationRecord
  belongs_to :associated, polymorphic: true
  belongs_to :user, class_name: 'Tramway::User::User'

  enumerize :associated_type, in: [Courses::Video, Products::Task, Podcast::Episode]

  scope :logged_by, lambda { |user, associated|
    minutes = associated.time_logs.where(user_id: user).sum(&:minutes)
    "#{minutes / 60}h #{minutes % 60}m"
  }

  validates :comment, presence: true
  validates :time_spent, presence: true
  validates :time_spent, time: true

  include TimeManager

  def minutes
    minutes_of time_spent
  end
end
