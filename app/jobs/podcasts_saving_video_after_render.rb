# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/benchkiller_bot'
require_relative '../../lib/tasks/bot_telegram/benchkiller_bot/notify'

class PodcastsSavingVideoAfterRender < ActiveJob::Base
  queue_as :podcast

  def perform(*_args)
    Podcast::Episode.find_each do |episode|
      episode.download_video_from_remote_host!
    end
  end
end
