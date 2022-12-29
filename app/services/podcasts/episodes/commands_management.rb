# frozen_string_literal: true

module Podcasts::Episodes::CommandsManagement
  def run(command, output:, action:, name: nil)
    episode.log_command action, command
    Rails.logger.info command

    _log, _err, _status = Open3.capture3({}, command, {})
  end
end
