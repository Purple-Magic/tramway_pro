module Podcast::Episodes::SocialPostsConcern
  def vk_post_text
    text = object.public_title || ''
    text += "<br/><br/>Ведущие:<br/>"
    object.stars.each do |star|
      if star.vk.present?
        text += "🎙 @#{star.vk} (#{star.first_name} #{star.last_name})"
      else
        text += "🎙 #{star.first_name} #{star.last_name}"
      end
      text += "<br/>"
    end
    text += "<br/>"
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}<br/>"
    end
    text += "<br/>"
    text += "Музыка @alpharecords73 (ALPHA RECORDS)<br/>"
    text += "Художник: @kiborgvviborge (noTea)"
    raw text
  end

  def telegram_post_text
    text = object.public_title || ''
    text += "\n\nВедущие:\n"
    object.stars.each do |star|
      if star.telegram.present?
        text += "🎙 @#{star.telegram}"
      else
        text += "🎙 #{star.first_name} #{star.last_name}"
      end
      text += "\n"
    end
    text += "\n"
    instances.each do |instance|
      text += "#{instance.service.capitalize}: #{instance.shortened_url}\n"
    end
    text += "\n"
    text += "Художник: @cathrinenotea"
  end
end
