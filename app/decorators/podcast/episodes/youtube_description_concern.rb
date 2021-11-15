# frozen_string_literal: true

module Podcast::Episodes::YoutubeDescriptionConcern
  def youtube_description
    youtube_header
    youtube_stars_list
    youtube_guest_list if object.with_guests?
    youtube_minor_list if object.with_minor?
    youtube_topics_list
    youtube_links_list
    youtube_static_content
    raw @youtube_description
  end

  private

  def youtube_header
    @youtube_description = "Вы можете прослушать выпуск подкаста на этих площадках:"
    @youtube_description += instances.map do |instance|
      "* #{instance.service.capitalize} #{instance.shortened_url}"
    end.join("<br/>")
    @youtube_description += "<br/><br/>"
  end

  private

  def youtube_stars_list
    @youtube_description += 'Ведущие:<br/>'
    @youtube_description += object.stars.main.map do |star|
      "* @#{star.nickname} #{star.link}\n"
    end.join "<br/>"
    @youtube_description += "<br/><br/>"
  end

  def youtube_guest_list
    @youtube_description += 'Гости:<br/>'
    @youtube_description += object.stars.guest.map do |star|
      "* @#{star.nickname} #{star.link}\n"
    end.join "<br/>"
    @youtube_description += "<br/><br/>"
  end

  def youtube_minor_list
    @youtube_description += 'Эпизодическое участие:<br/>'
    @youtube_description += object.stars.minor.map do |star|
      "* @#{star.nickname} #{star.link}\n"
    end.join "<br/>"
    @youtube_description += "<br/><br/>"
  end

  def youtube_topics_list
    @youtube_description += 'Темы выпуска<br/>'
    @youtube_description += topics.map do |topic|
      "* #{topic.title} #{topic.link}"
    end.join("<br/>")
    @youtube_description += "<br/><br/>"
  end

  def youtube_links_list
    return unless object.links.any?

    @youtube_description += 'Ссылки'
    @youtube_description += object.links.map do |link|
      "* #{link.title} #{link.link}"
    end.join("<br/>")
    @youtube_description += "<br/><br/>"
  end

  def youtube_static_content
    @youtube_description += podcast.youtube_footer&.gsub("\n", "<br/>")
  end
end
