# frozen_string_literal: true

class Admin::Estimation::CostForm < Tramway::ApplicationForm
  properties :price, :project_id, :associated_id, :associated_type

  association :associated

  def initialize(object)
    super(object).tap do
      form_properties associated: :polymorphic_association,
        price: :float
    end
  end
end
