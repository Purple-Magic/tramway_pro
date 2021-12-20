# frozen_string_literal: true

class Night::BotForm < Tramway::Core::ApplicationForm
  properties :name, :project_id, :options

  def initialize(object)
    super(object).tap do
      form_properties name: :string,
        options: :text
    end
  end

  def options=(value)
    model.options = YAML.safe_load(value)
  end

  def options
    YAML.dump(model.options).sub("---\n", '')
  end
end
