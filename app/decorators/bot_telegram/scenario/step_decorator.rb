# frozen_string_literal: true

class BotTelegram::Scenario::StepDecorator < Tramway::Core::ApplicationDecorator
  class << self
    def show_attributes
      %i[
        title
        text
        options
        reply_markup
        file
        delay
        actions
      ]
    end
  end

  delegate_attributes :text, :delay

  def title
    object.name
  end

  def name
    "#{object.name} - #{object.text.first(50)}..."
  end

  def file
    file_view object.file
  end

  def options
    yaml_view object.options
  end

  def reply_markup
    yaml_view object.reply_markup
  end

  def actions
    filter = { auditable_id_eq: object.id, auditable_type_eq: BotTelegram::Scenario::Step }
    href = Tramway::Admin::Engine.routes.url_helpers.records_path(model: Audited::Audit, filter: filter)
    content_tag :a, href: href do
      'Действия'
    end
  end
end
