class Admin::MagicWood::ActorForm < Tramway::Core::ApplicationForm
  properties :first_name, :last_name, :state, :project_id

  def initialize(object)
    super(object).tap do
      form_properties first_name: :string,
        last_name: :string
    end
  end
end
