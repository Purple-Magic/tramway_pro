class Admin::ItWay::ContentForm < Tramway::Core::ApplicationForm
  properties :content_type, :title, :associated_id, :associated_type, :preview, :project_id

  association :associated

  def initialize(object)
    super(object).tap do
      form_properties  title: :string,
        content_type: :default,
        associated: :polymorphic_association,
        preview: :file
    end
  end
end
