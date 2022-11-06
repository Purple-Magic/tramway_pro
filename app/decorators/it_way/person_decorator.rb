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

  def elite_karma
    karma = 0
    data = []

    episodes&.each do |episode|
      role = episode[:role]
      points = WEIGHTS[:podcast][role.to_sym]
      data << { title: episode[:public_title], role: role.text, points: points, type: :podcast }
      karma += points
    end

    participations.each do |participation|
      case participation.content.model.class.to_s
      when 'ItWay::Content'
      when 'Tramway::Event::Section'
        key = participation.content.event.id.in?(FORUMS_IDS) ? :forum : :offline_conf
        role = participation.role
        points = WEIGHTS[key][role.to_sym]
        data << { title: participation.content.event.title, role: role.text, points: points, type: key }
        karma += points
      end
    end

    {
      points: karma,
      data: data
    }
  end

  def karma
    karma = 0
    data = []

    if telegram_user.present?
      telegram_messages_count = telegram_user.messages.where(chat_id: 1694).count 
      data << {
        title: object.class.human_attribute_name(:messages_at_it_way_chat),
        points: telegram_messages_count,
        type: :chat
      }
      karma += telegram_messages_count
    end

    if points.any?
      sum = points.sum(&:count)
      data << { title: 'Дополнительные очки', points: sum  }
      karma += sum
    end

    {
      points: karma,
      data: data
    }
  end

  private

  def gold_medals
    {
      more_than_3_episodes: lambda { |person| person.episodes.count > 3 },
      telegram_messages_is_1000: lambda { |person| person.send(:telegram_user).messages.count >= 1000 },
      five_events: lambda { |person| person.participations.count >= 5 }
    }
  end

  def silver_medals
    {
      back_to_podcast: lambda { |person| person.episodes.count > 1 },
      telegram_messages_is_100: lambda { |person| person.send(:telegram_user).messages.count >= 100 },
      three_events: lambda { |person| person.participations.count >= 3 }
    }
  end

  def bronze_medals
    {
      one_episode: lambda { |person| person.episodes.any? },
      telegram_messages_is_10: lambda { |person| person.send(:telegram_user).messages.count >= 10 },
      one_event: lambda { |person| person.participations.any? }
    }
  end

  def telegram_user
    ::BotTelegram::User.unscoped.find_by(id: object.telegram_user_id)
  end
end
