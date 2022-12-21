# frozen_string_literal: true

class Podcasts::Episodes::BaseService < ApplicationService
  include Podcasts::Episodes::PathManagement
  include Podcasts::Episodes::TimeManagement
  include Podcasts::Episodes::CommandsManagement
  include Podcasts::Episodes::FilesManagement
  include Ffmpeg::CommandBuilder
  include Podcast::SoundProcessConcern

  def log_command(episode, action, command)
    line = [action, DateTime.now.strftime('%d.%m.%Y %H:%M:%S'), command].join(', ')
    commands = (episode.render_data&.dig('commands') || []) + [line]
    episode.render_data ? episode.render_data['commands'] = commands : episode.render_data = { commands: commands }
    episode.save!
  end
end
