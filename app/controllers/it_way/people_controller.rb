class ItWay::PeopleController < Tramway::Core::ApplicationController
  def index
  end

  def show
    @person = ItWay::PersonDecorator.new ItWay::Person.find params[:id]
    @episodes = Podcast::Star.unscoped.find(43).starrings.map do |starring|
      episode = Podcast::Episode.unscoped.find(starring.episode_id)
      podcast = Podcast.unscoped.find(episode.podcast_id)
      instances = Podcast::Episodes::Instance.unscoped.where(episode_id: episode.id)

      {
        image_url: podcast.default_image.url,
        public_title: episode.public_title,
        role: starring.star_type,
        links: instances.map do |instance|
          {
            service: instance.service.capitalize,
            link: instance.link
          }
        end
      }
    end
  end
end
