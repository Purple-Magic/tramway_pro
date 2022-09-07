class Admin::Blogs::LinkForm < Tramway::Core::ApplicationForm
  properties :url, :image, :title, :lead, :project_id

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        lead: :text,
        url: :string,
        image: :file
    end
  end
end
