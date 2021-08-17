# frozen_string_literal: true

class Podcast::Episodes::TopicForm < Tramway::Core::ApplicationForm
  properties :title, :link, :project_id

  def submit(params)
    params[:episode_id] = Podcast::Episode.last.id
    model.save!
    model.discus
    model.save!
  end
end
