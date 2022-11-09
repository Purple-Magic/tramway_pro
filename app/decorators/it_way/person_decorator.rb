class ItWay::PersonDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :first_name,
        :last_name,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
        :star_id,
        :avatar
  )

  decorate_associations :participations, :points, :event_person

  def title
    "#{first_name} #{last_name}"
  end

  def twitter_preview
    image_view object.twitter_preview
  end

  def avatar_view
    image_view object.avatar
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
        :twitter_preview,
        :avatar_view
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
      main_org: 200,
      org: 100,
      speaker: 50,
      trainer: 50,
      attender: 10
    },
    podcast: {
      main: 10,
      guest: 20,
      minor: 5
    },
    forum: {
      attender: 50,
      speaker: 100,
      trainer: 1000,
      org: 1000,
      main_org: 2000
    }
  }

  ROLES_ASSOC = {
    'Тренер' => :trainer,
    'Тренер направления "Программирование"' => :trainer,
    'Докладчик' => :speaker,
    'Организатор' => :org,
    'Программный комитет' => :org,
    'Самая главная по SMM' => :main_org,
    'Координатор' => :main_org,
    "Организатор массовых мероприятий" => :org
  }

  def episodes
    return [] unless object.star_id.present?

    @episodes ||= Podcast::Star.unscoped.find(object.star_id).starrings.map do |starring|
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
        end,
        published_at: episode.publish_date
      }
    end
  end

  def entities_count(entity)
    count = case entity
            when :episodes 
              public_send(entity).count
            when :participations
              if event_person.present?
                participations.count + event_person.partakings.count
              else
                participations.count
              end
            end
    if count == 1
      I18n.t("it_way.people.previews.show.#{entity}.one")
    elsif count > 1 && count < 5
      I18n.t("it_way.people.previews.show.#{entity}.few")
    elsif count > 5
      I18n.t("it_way.people.previews.show.#{entity}.lot")
    end
  end

  def participations_count
    if event_person.present?
      participations.count + event_person.partakings.count
    else
      participations.count
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

    if event_person.present?
      event_person.partakings.each do |partaking|
        event = partaking.part.object.is_a?(Tramway::Event::Event) ? partaking.part : partaking.part.event
        key = event.id.in?(FORUMS_IDS) ? :forum : :offline_conf
        role = partaking.position
        points = WEIGHTS[key][ROLES_ASSOC[role]]
        data << { title: event.title, role: role, points: points, type: key }
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

  def joined_at
    first_telegram_message = telegram_user.messages.order(:created_at).first.created_at.year if telegram_user.present?
    first_event = if participations.any?
                    participations.map do |participation|
                      participation.content.created_at
                    end.sort.first.year
                  end
    first_podcast_episode = episodes.select do |episode|
      episode[:published_at].present?
    end.sort_by do |episode|
      episode[:published_at]
    end.first[:published_at].year
    first_partaking = if event_person.present?
                        event_person.partakings.map do |partaking|
                          if partaking.part.object.is_a? Tramway::Event::Event
                            partaking.part.begin_date
                          else
                            partaking.part.event.begin_date
                          end
                        end.sort.first.year
                      end
    [first_podcast_episode, first_event, first_telegram_message, first_partaking].compact.min
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
