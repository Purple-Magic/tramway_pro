# frozen_string_literal: true

module Podcast::Episodes::VideoDecorator
  def trailer_video
    content_tag(:video, controls: true, width: '400px') do
      content_tag(:source, '', src: object.trailer_video.url)
    end
  end

  def full_video
    content_tag(:video, controls: true, width: '400px') do
      content_tag(:source, '', src: object.full_video.url)
    end
  end
end
