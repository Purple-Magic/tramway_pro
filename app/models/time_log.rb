# frozen_string_literal: true

class TimeLog < ApplicationRecord
  belongs_to :associated, polymorphic: true
  belongs_to :user, class_name: 'Tramway::User::User'

  enumerize :associated_type, in: [Courses::Video, Products::Task, Podcast::Episode]

  class << self
    include TimeManager
  end

  scope :logged_by, Proc.new { |user, associated, begin_date, end_date|
    collection = associated.time_logs.where(user_id: user)
    if begin_date.present?
      collection.where(created_at: begin_date..end_date)
    else
      collection
    end
  }

  scope :time_logged_by, Proc.new { |user, associated, begin_date, end_date|
    collection = logged_by user, associated, begin_date, end_date
    minutes = collection.sum(&:minutes)
    minutes_to_hours minutes
  }

  validates :comment, presence: true
  validates :time_spent, presence: true
  validates :time_spent, time: true

  include TimeManager

  def minutes
    minutes_of time_spent
  end

  def logging_actions
    YAML.load_file Rails.root.join('lib', 'yaml', 'time_logs_actions.yml')
  end
end
