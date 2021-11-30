# frozen_string_literal: true

class Admin::Podcast::Episodes::InstanceForm < Tramway::Core::ApplicationForm
  properties :state, :project_id, :service, :link

  association :episode

  def initialize(object)
    super(object).tap do
      form_properties episode: :association,
        service: :default,
        link: :string
    end
  end

  def submit(params)
    super(params).tap do
      ::Shortener::ShortenedUrl.generate(params[:link], owner: model)
    end
  end
end
