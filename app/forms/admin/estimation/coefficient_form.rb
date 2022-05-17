# frozen_string_literal: true

class Admin::Estimation::CoefficientForm < Tramway::Core::ApplicationForm
  properties :scale, :project_id, :title, :position, :coefficient_type

  association :estimation_project

  def initialize(object)
    super(object).tap do
      form_properties estimation_project: :association,
        title: :string,
        scale: :float,
        coefficient_type: :default,
        position: :integer
    end
  end
end
