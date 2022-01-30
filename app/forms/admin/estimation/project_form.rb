# frozen_string_literal: true

class Admin::Estimation::ProjectForm < Tramway::Core::ApplicationForm
  properties :title, :state, :project_id, :description, :associated_id, :associated_type

  association :customer
  association :associated

  def initialize(object)
    super(object).tap do
      form_properties customer: :association,
        title: :string,
        associated: :polymorphic_association,
        description: :ckeditor
    end
  end
end
