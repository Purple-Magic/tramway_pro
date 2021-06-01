# frozen_string_literal: true

class Tramway::News::NewsSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :title, :body, :published_at, :photo

  include ActionView::Helpers::OutputSafetyHelper

  def photo
    "http://#{ENV['PROJECT_URL']}#{object.photo.url}"
  end

  def published_at
    object.published_at&.strftime '%d.%m.%Y %H:%M'
  end

  def body
    raw object.body
  end
end
