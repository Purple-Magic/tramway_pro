class Admin::ItWay::ParticipationForm < Tramway::Core::ApplicationForm
  properties :person_id, :content_id, :state, :deleted_at, :project_id, :role

  association :person
  association :content

  def initialize(object)
    super(object).tap do
      form_properties person: :association,
        content: :association,
        role: :default
    end
  end
end
