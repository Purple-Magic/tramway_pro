# frozen_string_literal: true

class Admin::Podcast::Episodes::TopicForm < Tramway::Core::ApplicationForm
  properties :title, :link, :state, :project_id, :discus_state, :timestamp

  association :episode

  def initialize(object)
    super(object).tap do
      form_properties episode: :association,
        title: :string,
        link: :string
    end
  end
end
