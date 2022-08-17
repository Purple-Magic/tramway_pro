class Admin::FindMeds::BaseForm < Tramway::Core::ApplicationForm
  properties :name, :key, :project_id

  def initialize(object)
    super(object).tap do
      form_properties name: :string,
        key: :string
    end
  end
end
