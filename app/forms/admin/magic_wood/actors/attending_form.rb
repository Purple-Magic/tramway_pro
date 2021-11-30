# frozen_string_literal: true

class Admin::MagicWood::Actors::AttendingForm < Tramway::Core::ApplicationForm
  properties :state, :project_id

  association :actor
  association :estimation_project

  def initialize(object)
    super(object).tap do
      form_properties estimation_project: :association,
        actor: :association
    end
  end
end
