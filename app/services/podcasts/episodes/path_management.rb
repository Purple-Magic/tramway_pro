# frozen_string_literal: true

module Podcasts::Episodes::PathManagement
  def build_output(object:, attribute:, suffix: nil)
    directory = if object.is_a? Podcast::Episode
                  object.prepare_directory
                else
                  object.episode.prepare_directory
                end
    filename = [object.class, object.id, attribute, suffix].compact.join('_')
    "#{directory}/#{filename}.mp3"
  end

  def update_output(suffix, output)
    (output.split('.')[0..-2] + [suffix, :mp3]).join('.')
  end
end
