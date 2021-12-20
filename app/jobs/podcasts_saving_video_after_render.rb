# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/benchkiller_bot'
require_relative '../../lib/tasks/bot_telegram/benchkiller_bot/notify'

class PodcastsSavingVideoAfterRender < ActiveJob::Base
  queue_as :podcast

  def perform(*_args)
    Podcast::Episode.find_each do |episode|
      episode.update_file! "#{episode.prepare_directory}/full_video.mp4", :full_video
    end
  end
end
