class BotDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :name, :team

  decorate_association :steps

  class << self
    def list_attributes
      [ :users_count, :messages_count ]
    end

    def show_attributes
      [ :name, :team, :options, :users_count, :messages, :messages_count ]
    end

    def show_associations
      [ :steps ]
    end
  end

  def options
    yaml_view object.options
  end

  def users_count
    object.users.uniq.count
  end

  def messages_count
    object.progress_records.uniq.count
  end

  def messages
    content_tag :a, href: Tramway::Admin::Engine.routes.url_helpers.records_path(model: ::BotTelegram::Message, filter: { bot_id_eq: object.id }) do
      I18n.t('helpers.links.open')
    end
  end
end
