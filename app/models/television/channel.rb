class Television::Channel < ApplicationRecord
  has_many :schedule_items, class_name: 'Television::ScheduleItem'

  enumerize :channel_type, in: [ 'repeated', 'custom' ]

  aasm :broadcast_state do
    state :stopped, initial: true
    state :broadcasting

    event :start do
      transitions from: :stopped, to: :broadcasting

      after do
        save!
        if channel_type.repeated?
          start_remote_broadcast schedule_items.order(:position).first.command
        end
      end
    end

    event :stop do
      transitions from: :broadcasting, to: :stopped
    end
  end

  REMOTE_SERVER = "167.71.46.15"
  REMOTE_USER = "root"

  def start_remote_broadcast(command)
    command = "ssh -t #{REMOTE_USER}@#{REMOTE_SERVER} \"nohup /bin/bash -c '#{command}' &\""
    Rails.logger.info command
    system command
  end
end
