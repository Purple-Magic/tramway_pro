class Admin::PodcastForm < Tramway::Core::ApplicationForm
  properties :title, :feed_url

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        feed_url: :string
    end
  end
end
