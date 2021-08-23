# frozen_string_literal: true

class PodcastsTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id
    send_notification_to_user :kalashnikovisme, 'Podcast trailer render is started'
    episode.build_trailer
    send_notification_to_user :kalashnikovisme, 'Podcast trailer render is ended'
  end
end
