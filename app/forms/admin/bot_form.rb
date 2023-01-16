# frozen_string_literal: true

class Admin::BotForm < Tramway::ApplicationForm
  properties :name, :team, :project_id, :token, :options, :slug

  def initialize(object)
    super(object).tap do
      form_properties name: :string,
        team: :default,
        token: :string,
        slug: :string,
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
