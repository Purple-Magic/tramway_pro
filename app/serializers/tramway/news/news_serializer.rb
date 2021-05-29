# frozen_string_literal: true

class Tramway::News::NewsSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :title, :body, :published_at, :photo

  def photo
    object.photo.url
  end

  def published_at
    object.published_at.strftime '%d.%m.%Y %H:%M'
  end

  def body
    raw object.body
  end
end
