class Admin::VideoForm < Tramway::Core::ApplicationForm
  properties :url, :project_id

  def initialize(object)
    super(object).tap do
      form_properties url: :string
    end
  end
end
