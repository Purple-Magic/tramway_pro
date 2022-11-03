class ItWay::PersonDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :first_name,
        :last_name,
        :avatar,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
        :star_id
  )

  decorate_associations :participations, :points

  def title
    "#{first_name} #{last_name}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :first_name,
        :last_name,
        :avatar,
      ]
    end

    def show_attributes
      [
        :id,
        :first_name,
        :last_name,
        :avatar,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
      ]
    end

    def show_associations
      [ :participations, :points ]
    end

    def list_filters
    end
  end

  FORUMS_IDS = [14, 15, 16, 3, 26]

  WEIGHTS = {
    telegram_message: 1,
    offline_conf: {
      org: 100,
      speaker: 50,
      participant: 10
    },
    podcast: {
      main: 10,
      guest: 20,
      minor: 5
    },
    forum: {
      participant: 50,
      speaker: 100,
      trainer: 1000,
      org: 1000,
      main_org: 2000
    }
  }

  def episodes
    @episodes ||= Podcast::Star.unscoped.find(43).starrings.map do |starring|
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

  def stat_table
    karma = 0
    episodes&.each do |episode|
      karma += WEIGHTS[:podcast][episode[:role].to_sym]
    end
    telegram_user = ::BotTelegram::User.unscoped.find_by(id: object.telegram_user_id)
    karma += telegram_user.messages.where(chat_id: 1694).count if telegram_user.present?
    participations.each do |participation|
      case participation.content.model.class.to_s
      when 'ItWay::Content'
      when 'Tramway::Event::Section'
        key = participation.content.event.id.in?(FORUMS_IDS) ? :forum : :offline_conf
        karma += WEIGHTS[key][participation.role.to_sym]
      end
    end
    karma + points.sum(&:count)
  end
end
