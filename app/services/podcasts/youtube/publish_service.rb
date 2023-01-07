class Podcasts::Youtube::PublishService < ApplicationService
  include Podcasts

  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end

  def call
    publish
  end

  private

  def publish 
    if episode.full_video.path.present?
      account = Yt::Account.new access_token: ::Youtube::Account.last.access_token

      video = account.upload_video(
        episode.full_video.path,
        title: episode.public_title
        # description: Podcast::Youtube::VideoDecorator.new(episode).description
      )

      instance = episode.instances.create! service: :youtube, link: "https://www.youtube.com/watch?v=#{video.id}"
      ::Shortener::ShortenedUrl.generate(instance.link, owner: instance)
      instance = Podcast::Episodes::InstanceDecorator.new instance

      send_notification_to_chat episode.podcast.chat_id, notification(:youtube_publish, :success, link: instance.link)
    else
      send_notification_to_chat episode.podcast.chat_id, notification(:youtube_publish, :video_empty)
    end
  end
end
