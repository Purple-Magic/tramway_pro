# frozen_string_literal: true

module Podcasts::Episodes::CommandsManagement
  def run(command, output:, name: nil, action:)
    episode.log_command action, command
    Rails.logger.info command
    system command

    wait_for_file_rendered output, name
  end
end
