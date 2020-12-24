class BotTelegram::Scenario::StepDecorator < Tramway::Core::ApplicationDecorator
  class << self
    def show_attributes
      [
        :name,
        :text,
        :options,
        :reply_markup,
        :file,
        :delay,
        :actions
      ]
    end
  end

  delegate_attributes :name, :text, :options, :reply_markup, :file, :delay

  def actions
    href = Tramway::Admin::Engine.routes.url_helpers.records_path(model: Audited::Audit, filter: { auditable_id_eq: object.id, auditable_type_eq: BotTelegram::Scenario::Step })
    content_tag :a, href: href do
      "Действия"
    end
  end
end
