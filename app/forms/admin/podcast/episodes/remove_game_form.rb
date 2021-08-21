# frozen_string_literal: true

class Admin::Podcast::Episodes::RemoveStarForm < Tramway::Core::ApplicationForm
  properties :id

  def submit(params)
    model.stars -= [Podcast::Episodes::Star.find(params)] if id.present?
    model.save!
  end
end
