class Admin::Podcast::StatForm < Tramway::Core::ApplicationForm
  properties :month, :year, :service, :downloads, :streams, :listeners, :hours, :average_listenning,
    :overhearing_percent, :project_id

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        year: :numeric,
        month: :numeric,
        service: :default,
        downloads: :numeric,
        streams: :numeric,
        listeners: :numeric,
        hours: :numeric,
        average_listenning: :string,
        overhearing_percent: :string
    end
  end
end
