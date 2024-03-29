# frozen_string_literal: true

class Admin::Estimation::ProjectForm < Tramway::ApplicationForm
  properties :title, :state, :project_id, :description, :associated_id, :associated_type, :default_price

  association :customer
  association :associated

  def initialize(object)
    super(object).tap do
      form_properties customer: :association,
        title: :string,
        associated: :polymorphic_association,
        description: :ckeditor,
        default_price: :string
    end
  end
end
