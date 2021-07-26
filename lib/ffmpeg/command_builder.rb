# frozen_string_literal: true

module Ffmpeg::CommandBuilder
  def options_line(inputs:, output:, **options)
    line = options[:yes] ? '-y ' : ''
    line += "-loop #{options[:loop_value]} " if options[:loop_value].present?
    inputs.each do |input|
      line += "-i #{input} "
    end
    arguments = []
    arguments << "c:v #{options[:video_codec]}" if options[:video_codec].present?
    arguments << "tune #{options[:tune]}" if options[:tune].present?
    arguments << "c:a #{options[:audio_codec]}" if options[:audio_codec].present?
    arguments << "pix_fmt #{options[:pixel_format]}" if options[:pixel_format].present?
    arguments << 'shortest' if options[:shortest]
    arguments << "strict -#{options[:strict]}" if options[:strict].present?
    arguments.each do |argument|
      line += "-#{argument} "
    end
    "#{line}#{output}"
  end
end
