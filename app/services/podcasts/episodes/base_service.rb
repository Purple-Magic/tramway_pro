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
end
