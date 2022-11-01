class Admin::ItWay::ParticipationForm < Tramway::Core::ApplicationForm
  properties :person_id, :content_id, :state, :deleted_at, :project_id, :role, :content_type

  association :person
  association :content

  def initialize(object)
    super(object).tap do
      form_properties person: :association,
        content: :polymorphic_association,
        role: :default
    end
  end
end
