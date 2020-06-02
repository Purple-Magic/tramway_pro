# frozen_string_literal: true

class Admin::ProjectForm < Tramway::Core::ApplicationForm
  properties :title, :description, :url

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
                      description: :text,
                      url: :string
    end
  end
end
