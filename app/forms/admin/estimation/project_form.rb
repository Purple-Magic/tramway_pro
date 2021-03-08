# frozen_string_literal: true

class Admin::Estimation::ProjectForm < Tramway::Core::ApplicationForm
  properties :title, :state, :project_id, :description

  association :customer

  def initialize(object)
    super(object).tap do
      form_properties customer: :association,
                      title: :string,
                      description: :ckeditor
    end
  end
end
