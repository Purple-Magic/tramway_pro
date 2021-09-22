# frozen_string_literal: true

module Ffmpeg::CommandBuilder
  include Ffmpeg::Base
  include Ffmpeg::PodcastSpecific

  def options_line(inputs:, output:, **options)
    line = options[:yes] ? '-y ' : ''
    line += "-loop #{options[:loop_value]} " if options[:loop_value].present?
    inputs.each do |input|
      line += "-i #{input} "
    end
    arguments = build_arguments options
    arguments << "strict -#{options[:strict]}" if options[:strict].present?
    arguments.each do |argument|
      line += "-#{argument} "
    end
    "#{line}#{output}"
  end

  private

  ARGUMENTS = {
    video_codec: 'c:v',
    tune: :tune,
    audio_codec: 'c:a',
    pixel_format: :pix_fmt,
    shortest: :boolean,
    audio_bitrate: 'b:a',
    copy: 'c',
    add_filters: 'af',
    filter_complex: :filter_complex,
    map: :map,
    ss: :ss,
    to: :to
  }.freeze

  def build_arguments(options)
    ARGUMENTS.map do |pair|
      key = pair[0]
      next unless options[key].present?

      case pair[1]
      when :boolean
        key
      else
        "#{pair[1]} #{options[key]}"
      end
    end.compact
  end
end
