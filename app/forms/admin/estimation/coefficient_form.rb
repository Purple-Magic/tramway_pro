# frozen_string_literal: true

class Admin::Estimation::CoefficientForm < Tramway::Core::ApplicationForm
  properties :scale, :project_id, :title

  association :estimation_project

  def initialize(object)
    super(object).tap do
      form_properties estimation_project: :association,
                      title: :string,
                      scale: :float
    end
  end
end
