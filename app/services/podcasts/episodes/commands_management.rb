# frozen_string_literal: true

module Podcasts::Episodes::CommandsManagement
  def run(command, action:, name: nil)
    episode.log_command action, command
    Rails.logger.info command

    _log, err, status = Open3.capture3({}, command, {})

    if !status.success? && err.present?
      episode.log_error(err) 
    end
  end
end
