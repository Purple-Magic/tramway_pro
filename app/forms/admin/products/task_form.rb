# frozen_string_literal: true

class Admin::Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :description

  association :product

  def initialize(object)
    super(object).tap do
      form_properties product: :association,
        title: :string,
        description: :text
    end
  end
end
