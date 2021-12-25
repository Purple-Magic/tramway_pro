class Admin::Television::VideoForm < Tramway::Core::ApplicationForm
  properties :title, :file, :project_id

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        file: :default
    end
  end
end
