# frozen_string_literal: true

module Podcast::Episodes::SocialPostsConcern
  def vk_post_text
    text = object.public_title || ''
    text += '<br/><br/>Ведущие:<br/>'
    object.stars.main.each do |star|
      text += if star.vk.present?
                "🎙 @#{star.vk} (#{star.first_name} #{star.last_name})"
              else
                "🎙 #{star.first_name} #{star.last_name}"
              end
      text += '<br/>'
    end
    if object.with_guests?
      text += '<br/>Гости:<br/>'
      object.stars.guest.each do |star|
        text += if star.vk.present?
                  "@#{star.vk} (#{star.first_name} #{star.last_name})"
                else
                  "#{star.first_name} #{star.last_name}"
                end
        text += '<br/>'
      end
    end
    if object.with_minor?
      text += '<br/>Эпизодическое участие:<br/>'
      object.stars.minor.each do |star|
        text += if star.vk.present?
                  "@#{star.vk} (#{star.first_name} #{star.last_name})"
                else
                  "#{star.first_name} #{star.last_name}"
                end
        text += '<br/>'
      end
    end
    text += '<br/>'
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}<br/>"
    end
    text += 'RSS: http://bit.ly/2JuDkYY<br/>'
    text += '<br/>'
    text += 'Музыка @alpharecords73 (ALPHA RECORDS)<br/>'
    text += 'Художник: @kiborgvviborge (noTea)'
    raw text
  end

  def telegram_post_text
    text = object.public_title || ''
    text += "\n\nВедущие:\n"
    object.stars.main.each do |star|
      text += if star.telegram.present?
                "🎙 @#{star.telegram}"
              else
                "🎙 #{star.first_name} #{star.last_name}"
              end
      text += "\n"
    end
    if object.with_guests?
      text += "\nГости:\n"
      object.stars.guest.each do |star|
        text += if star.telegram.present?
                  "@#{star.telegram}"
                else
                  "#{star.first_name} #{star.last_name}"
                end
        text += "\n"
      end
    end
    if object.with_minor?
      text += "\nЭпизодическое участие:\n"
      object.stars.minor.each do |star|
        text += if star.telegram.present?
                  "@#{star.telegram}"
                else
                  "#{star.first_name} #{star.last_name}"
                end
        text += "\n"
      end
    end
    text += "\n"
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}\n"
    end
    text += "RSS: http://bit.ly/2JuDkYY\n"
    text += "\n"
    text += 'Художник: @cathrinenotea'
  end

  def telegram_post_text_with_trailer
    text = 'Обязательно послушайте трейлер выпуска! Приложил его сюда :)'
    text += "\n"
    text += "http://it-way.pro/#{object.shortened_urls.find_by(url: object.trailer_video.url)&.unique_key}"
  end

  def instagram_post_text
    content_tag(:pre) do
      id = "instagram_text_for_#{object.id}"
      concat(content_tag(:span, id: id) do
        text = object.public_title || ''
        text += 'Слушайте на Яндекс.Музыке, Google Podcasts, Youtube и других сервисах подкастов'
        text += "\n\nВедущие:\n"
        object.stars.main.each do |star|
          text += if star.instagram.present?
                    "🎙 @#{star.instagram}"
                  else
                    "🎙 #{star.first_name} #{star.last_name}"
                  end
          text += "\n"
        end
        if object.with_guests?
          text += "\nГости:\n"
          object.stars.guest.each do |star|
            text += if star.instagram.present?
                      "@#{star.instagram}"
                    else
                      "#{star.first_name} #{star.last_name}"
                    end
            text += "\n"
          end
        end
        if object.with_minor?
          text += "\nЭпизодическое участие:\n"
          object.stars.minor.each do |star|
            text += if star.instagram.present?
                      "@#{star.instagram}"
                    else
                      "#{star.first_name} #{star.last_name}"
                    end
            text += "\n"
          end
        end
        text += "\n"
        text += 'Музыка @alpharecords73'
        text += 'Художник: @no___tea'
      end)
      concat copy_to_clipboard id
    end
  end

  def twitter_post_text
    text = object.public_title || ''
    text += '<br/><br/>Ведущие:<br/>'
    object.stars.main.each do |star|
      text += if star.twitter.present?
                "🎙 @#{star.twitter}"
              else
                "🎙 #{star.first_name} #{star.last_name}"
              end
      text += '<br/>'
    end
    if object.with_guests?
      text += '<br/>Гости:<br/>'
      object.stars.guest.each do |star|
        text += if star.twitter.present?
                  "@#{star.twitter}"
                else
                  "#{star.first_name} #{star.last_name}"
                end
        text += '<br/>'
      end
    end
    if object.with_minor?
      text += '<br/>Эпизодическое участие:<br/>'
      object.stars.minor.each do |star|
        text += if star.twitter.present?
                  "@#{star.twitter}"
                else
                  "#{star.first_name} #{star.last_name}"
                end
        text += '<br/>'
      end
    end
    text += '<br/>'
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}<br/>"
    end
    text += 'RSS: http://bit.ly/2JuDkYY<br/>'
    raw text
  end
end
