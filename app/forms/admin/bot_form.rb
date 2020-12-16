class Admin::BotForm < Tramway::Core::ApplicationForm
  properties :name, :team, :project_id, :string

  def initialize(object)
    super(object).tap do
      form_properties name: :string,
        team: :default,
        token: :string
    end
  end
end
