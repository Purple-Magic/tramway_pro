# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/leopold/notify'

class LeopoldSendItWayHistoryJob < ActiveJob::Base
  queue_as :default

  include ::BotTelegram::Leopold::Notify

  def perform(*_args)
    Podcast.find(2).episodes.each do |episode|
      next if episode.id.in? [209, 208, 207, 205, 212, 274, 210]

      send_if_anniversary Podcast::EpisodeDecorator.decorate(episode)
    end
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def send_if_anniversary(content)
    if content.publish_date.present?
      return unless content.publish_date.strftime('%d.%m') == DateTime.now.strftime('%d.%m')
      return if content.publish_date.year == DateTime.now.year

      send_file_to_channel(
        ::BotTelegram::Leopold::ItWayPro::HISTORY_CHANNEL,
        content.model.trailer_video.path,
        caption: content.telegram_reminder_post_text
      )
    else
      send_notification_to_chat(
        ::BotTelegram::Leopold::ItWayPro::CHAT_ID,
        "Выпуск #{content.title} не имеет даты публикации. Добавьте её здесь http://red-magic.ru/admin/records/#{content.id}?model=Podcast%3A%3AEpisode" 
      )
    end
  end
end
