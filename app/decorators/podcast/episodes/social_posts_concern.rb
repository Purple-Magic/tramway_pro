# frozen_string_literal: true

module Podcast::Episodes::SocialPostsConcern
  def vk_post_text
    text = title
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

  def telegram_posts
    table do
      object.podcast.channels.in_telegram.each do |channel|
        concat(thead do
          concat(th do
            channel.title
          end)
        end)
        concat(content_tag(:tbody) do
          concat(tr do
            concat(td do
              raw telegram_post_text(channel).gsub "\n", '<br/>'
            end)
          end) 
        end)
      end
    end
  end

  def telegram_post_text(channel)
    text = title
    text = telegram_post_text_body text
    channel.footer.present? ? text + channel.footer : text
  end

  def telegram_reminder_post_text
    text = title
    text += "\n\n"
    years = TimeDifference.between(DateTime.now, publish_date).in_years.round
    ago = if years == 1
            '1 год'
          elsif years < 4
            "#{years} года"
          else
            "#{years} лет"
          end
    text += "В этот день #{ago} назад у нас вышел этот эпизод подкаста."

    text = telegram_post_text_body text
    text += "RSS: http://bit.ly/2JuDkYY\n"
    text += "\n"
    text += 'Художник: @cathrinenotea'
    text
  end

  def instagram_post_text
    content_tag(:pre) do
      id = "instagram_text_for_#{object.id}"
      concat(content_tag(:span, id: id) do
        text = title
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
    text = title
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

  def patreon_post_text
    content_tag(:div) do
      stars_list
      guest_list if object.with_guests?
      minor_list if object.with_minor?
      concat('Слушайте наши выпуски на платформах:')
      concat(content_tag(:ul) do
        instances.each do |instance|
          next unless instance.shortened_url.present?

          concat(content_tag(:li) do
            concat("#{instance.service.capitalize}: ")
            concat(link_to(instance.shortened_url, instance.shortened_url))
          end)
        end
        content_tag(:li) do
          concat('RSS: ')
          concat(link_to('http://bit.ly/2JuDkYY', 'http://bit.ly/2JuDkYY'))
        end
      end)
    end
  end

  private

  def telegram_post_text_body(text)
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
    text += strip_tags(object.description || '')
    text += "\n\n"
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}\n"
    end
    text
  end
end
