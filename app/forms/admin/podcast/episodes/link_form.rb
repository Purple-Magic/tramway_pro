# frozen_string_literal: true

class Admin::Podcast::Episodes::LinkForm < Tramway::Core::ApplicationForm
  properties :title, :link, :project_id

  association :episode

  def initialize(object)
    super(object).tap do
      form_properties episode: :association,
        title: :string,
        link: :string
    end
  end
end
