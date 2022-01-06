# frozen_string_literal: true

class Television::Channel < ApplicationRecord
  include Video::UploadConcern

  has_many :schedule_items, class_name: 'Television::ScheduleItem'

  store_accessor :rtmp, :url
  store_accessor :rtmp, :password

  enumerize :channel_type, in: %w[repeated custom]

  aasm :broadcast_state do
    state :stopped, initial: true
    state :broadcasting

    event :start do
      transitions from: :stopped, to: :broadcasting

      after do
        save!
        if channel_type.repeated?
          first_schedule_item = schedule_items.order(:position).first
          start_remote_broadcast first_schedule_item.command
        end
      end
    end

    event :stop do
      transitions from: :broadcasting, to: :stopped
    end
  end

  REMOTE_SERVER = '167.71.46.15'
  REMOTE_USER = 'root'

  def start_remote_broadcast(command)
    command = "ssh -t #{REMOTE_USER}@#{REMOTE_SERVER} \"nohup /bin/bash -c '#{command}' &\""
    Rails.logger.info command
    # system command
  end
end
