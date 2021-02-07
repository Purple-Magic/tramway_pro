class Admin::BotForm < Tramway::Core::ApplicationForm
  properties :name, :team, :project_id, :token, :options

  def initialize(object)
    super(object).tap do
      form_properties name: :string,
                      team: :default,
                      token: :string,
                      options: :text
    end
  end

  def options=(value)
    model.options = YAML.load(value)
  end

  def options
    YAML.dump(model.options).sub("---\n", '')
  end
end
