# frozen_string_literal: true

class Admin::Podcast::Episodes::TopicForm < Tramway::Core::ApplicationForm
  properties :episode_id, :title, :link, :state, :project_id, :discus_state, :timestamp

  def initialize(object)
    super(object).tap do
      form_properties episode_id: :integer,
        title: :text,
        link: :text,
        state: :text,
        project_id: :integer,
        discus_state: :text,
        timestamp: :text
    end
  end
end
