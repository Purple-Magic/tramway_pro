# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/benchkiller_bot'
require_relative '../../lib/tasks/bot_telegram/benchkiller_bot/notify'

class PodcastsSavingVideoAfterRender < ActiveJob::Base
  queue_as :podcast

  def perform(*_args)
    Podcast::Episode.find_each do |episode|
      file_path = "#{episode.prepare_directory}/full_video.mp4", :full_video
      next unless File.exist? file_path
      episode.update_file! file_path
    end
  end
end
