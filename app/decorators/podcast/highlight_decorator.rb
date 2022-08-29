# frozen_string_literal: true

class Podcast::HighlightDecorator < ApplicationDecorator
  delegate_attributes :time, :cut_begin_time, :cut_end_time, :using_state

  decorate_association :episode

  include Concerns::AudioControls

  class << self
    def show_attributes
      %i[episode_link listen time cut_begin_time cut_end_time using_state]
    end
  end

  def title
    "#{object.trailer_position} | #{object.time} - #{object.using_state}"
  end

  def episode_link
    link_to episode.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.episode_id, model: 'Podcast::Episode')
  end

  def listen
    audio do
      content_tag(:source, '', src: object.file.url)
    end
  end
end
