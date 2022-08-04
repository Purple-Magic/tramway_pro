# frozen_string_literal: true

class Podcasts::YoutubePublishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    account = Yt::Account.new access_token: ::Youtube::Account.last.access_token

    video = account.upload_video(
      episode.full_video.path,
      title: episode.public_title,
      description: Podcast::Youtube::VideoDecorator.new(episode).description,
      privacyStatus: :private
    )

    instance = episode.instances.create! service: :youtube, link: "https://www.youtube.com/watch?v=#{video.id}"
    ::Shortener::ShortenedUrl.generate(instance.link, owner: instance)
    instance = Podcast::Episodes::InstanceDecorator.new instance

    send_notification_to_chat episode.podcast.chat_id, notification(:youtube_publish, :success, link: instance.link)
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end
end
