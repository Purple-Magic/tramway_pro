# frozen_string_literal: true

class Admin::Estimation::CustomerForm < Tramway::Core::ApplicationForm
  properties :title, :logo, :url, :project_id, :state

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
                      logo: :file,
                      url: :string
    end
  end
end
