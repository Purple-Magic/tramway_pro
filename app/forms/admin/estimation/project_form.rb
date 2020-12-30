class Admin::Estimation::ProjectForm < Tramway::Core::ApplicationForm
  properties :title, :state, :project_id

  association :customer

  def initialize(object)
    super(object).tap do
      form_properties customer: :association,
        title: :string
    end
  end
end
