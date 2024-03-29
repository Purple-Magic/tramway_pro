# frozen_string_literal: true

class Admin::Podcast::Episodes::AddStarForm < Tramway::ApplicationForm
  properties :star_ids, :podcast_id
  association :stars

  class << self
    def associated_as
      :podcast_episode
    end
  end

  def initialize(object)
    super(object).tap do
      form_properties stars: :association
    end
  end

  def submit(params)
    params[:star_ids].each do |id|
      model.stars << Podcast::Star.find(id) if id.present?
    end
    model.save!
  end
end
