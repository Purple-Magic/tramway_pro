# frozen_string_literal: true

class Admin::TramwayDevForm < Tramway::Core::ApplicationForm
  properties :name, :public_name, :tagline, :title, :project_id

  def initialize(obj)
    super(obj).tap do
      form_properties title: :string,
                      public_name: :string,
                      tagline: :string,
                      name: :string
    end
  end
end
