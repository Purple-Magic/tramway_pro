# frozen_string_literal: true

module Ffmpeg::CommandBuilder
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
    shortest: :boolean
  }.freeze

  def build_arguments(options)
    ARGUMENTS.map do |pair|
      next unless options[pair[0]].present?

      case pair[1]
      when :boolean
        pair[0]
      else
        "#{pair[1]} #{options[pair[0]]}"
      end
    end
  end
end
