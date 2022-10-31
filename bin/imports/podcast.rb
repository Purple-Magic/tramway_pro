require 'rss'
require 'httparty'

include ActionView::Helpers::SanitizeHelper

response = HTTParty.get 'https://feeds.redcircle.com/5a51ca0b-c930-480a-85f4-94a5f2190530'

feed = RSS::Parser.parse response.body

feed.items.each do |item|
  number = item.title.match(/Episode \d+/).to_s.sub('Episode ', '').to_i
  if number < 71
    params = {
      number: number,
      public_title: item.title,
      description: item.description,
      publish_date: item.pubDate
    }
    episode = Podcast::Episode.create! podcast_id: 2, project_id: 9, **params
    item.description.scan(/\@[A-Za-z0-9_\.]+/).each do |nickname|
      nickname = '@Wolf_Musing' if nickname == '@wolffyj' || nickname == "@my_marty"
      nickname = '@dmitry_daw' if nickname == '@xaykot'
      nickname = '@blue_kirpichic' if nickname == '@kirpi_pika'

      next if nickname.in? [ "@simbirsoft", "@iwanushek", "@apolosova", "@a_apolosova", "@catamphetamine" ]

      star = Podcast::Star.find_by nickname: nickname.sub('@', '')
      role = if nickname.in? [ '@kalashnikovisme', '@Wolf_Musing', '@darya.bazhenova' ]
               :main
             else
               :guest
             end
      Podcast::Episodes::Star.create! episode_id: episode.id, star_id: star.id, star_type: role
    end
  end
end
