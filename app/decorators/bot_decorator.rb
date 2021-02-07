class BotDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :name, :team

  decorate_association :steps

  class << self
    def list_attributes
      %i[users_count messages_count custom]
    end

    def show_attributes
      %i[name team options users_count messages messages_count]
    end

    def show_associations
      [:steps]
    end
  end

  def options
    yaml_view object.options
  end

  def users_count
    if object.custom
      object.messages.map(&:user).flatten.uniq.count
    else
      object.users.uniq.count
    end
  end

  def messages_count
    if object.custom
      object.messages.count
    else
      object.progress_records.uniq.count
    end
  end

  def messages
    content_tag :a, href: Tramway::Admin::Engine.routes.url_helpers.records_path(model: ::BotTelegram::Message, filter: { bot_id_eq: object.id }) do
      I18n.t('helpers.links.open')
    end
  end

  def custom
    if object.custom
      I18n.t('helpers.yes')
    else
      I18n.t('helpers.no')
    end
  end
end
