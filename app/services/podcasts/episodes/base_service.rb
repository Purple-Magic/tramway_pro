# frozen_string_literal: true

class Podcasts::Episodes::BaseService < ApplicationService
  include Podcasts::Episodes::PathManagement
  include Podcasts::Episodes::TimeManagement
  include Podcasts::Episodes::CommandsManagement
  include Podcasts::Episodes::FilesManagement
  include Ffmpeg::CommandBuilder

  def log_command(episode, action, command)
    line = [action, DateTime.now.strftime('%d.%m.%Y %H:%M:%S'), command].join(', ')
    commands = (episode.render_data&.dig('commands') || []) + [line]
    episode.render_data ? episode.render_data['commands'] = commands : episode.render_data = { commands: commands }
    episode.save!
  end

  def update_file!(episode, output, file_type)
    File.open(output) do |std_file|
      episode.public_send "#{file_type}=", std_file
    end
    episode.save!
  end

  def wait_for_file_rendered(output, file_type)
    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      message = "#{file_type} file does not exist for #{index} seconds"
      Rails.logger.info message
    end
  end

  # :reek:UtilityFunction { enabled: false }
  def write_logs(command)
    "#{command} 2> #{Rails.root}/log/render-#{Rails.env}.log"
  end
  # :reek:UtilityFunction { enabled: true }

  def move_to(temp_output, output)
    "mv #{temp_output} #{output} && rm -f #{temp_output}"
  end
end
