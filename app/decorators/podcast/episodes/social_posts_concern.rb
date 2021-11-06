module Podcast::Episodes::SocialPostsConcern
  def vk_post_text
    text = object.public_title || ''
    text += "<br/><br/>Ведущие:<br/>"
    object.stars.main.each do |star|
      if star.vk.present?
        text += "🎙 @#{star.vk} (#{star.first_name} #{star.last_name})"
      else
        text += "🎙 #{star.first_name} #{star.last_name}"
      end
      text += "<br/>"
    end
    text += "<br/>Гости:<br/>"
    object.stars.guest.each do |star|
      if star.vk.present?
        text += "@#{star.vk} (#{star.first_name} #{star.last_name})"
      else
        text += "#{star.first_name} #{star.last_name}"
      end
      text += "<br/>"
    end
    text += "<br/>Эпизодическое участие:<br/>"
    object.stars.minor.each do |star|
      if star.vk.present?
        text += "@#{star.vk} (#{star.first_name} #{star.last_name})"
      else
        text += "#{star.first_name} #{star.last_name}"
      end
      text += "<br/>"
    end
    text += "<br/>"
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}<br/>"
    end
    text += "RSS: http://bit.ly/2JuDkYY<br/>"
    text += "<br/>"
    text += "Музыка @alpharecords73 (ALPHA RECORDS)<br/>"
    text += "Художник: @kiborgvviborge (noTea)"
    raw text
  end

  def telegram_post_text
    text = object.public_title || ''
    text += "\n\nВедущие:\n"
    object.stars.main.each do |star|
      if star.telegram.present?
        text += "🎙 @#{star.telegram}"
      else
        text += "🎙 #{star.first_name} #{star.last_name}"
      end
      text += "\n"
    end
    text += "\nГости:\n"
    object.stars.guest.each do |star|
      if star.telegram.present?
        text += "@#{star.telegram}"
      else
        text += "#{star.first_name} #{star.last_name}"
      end
      text += "\n"
    end
    text += "\nЭпизодическое участие:\n"
    object.stars.minor.each do |star|
      if star.telegram.present?
        text += "@#{star.telegram}"
      else
        text += "#{star.first_name} #{star.last_name}"
      end
      text += "\n"
    end
    text += "\n"
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}\n"
    end
    text += "RSS: http://bit.ly/2JuDkYY\n"
    text += "\n"
    text += "Художник: @cathrinenotea"
  end

  def telegram_post_text_with_trailer
    text = "Обязательно послушайте трейлер выпуска! Приложил его сюда :)"
    text += "\n"
    text += "http://it-way.pro/#{object.shortened_urls.find_by(url: object.trailer_video.url)&.unique_key}"
  end
end
