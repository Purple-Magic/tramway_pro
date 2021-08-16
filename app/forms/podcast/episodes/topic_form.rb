# frozen_string_literal: true

class Podcast::Episodes::TopicForm < Tramway::Core::ApplicationForm
  properties :title, :link, :project_id
end
