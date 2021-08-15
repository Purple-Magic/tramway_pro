# frozen_string_literal: true

module Ffmpeg::CommandBuilder
  CODECS = {
    mp3: :libmp3lame
  }.freeze

  def convert_to(format, input:, output:)
    "ffmpeg -y -i #{input} -b:a 320k -c:a #{CODECS[format]} #{output}"
  end

  def render_video_from(image, sound, output:)
    options = options_line(yes: true, loop_value: 1, inputs: [image, sound], video_codec: :libx264, tune: :stillimage,
      audio_codec: :aac, audio_bitrate: '192k', pixel_format: :yuv420p, shortest: true, output: output)
    "ffmpeg #{options}"
  end

  def content_concat(inputs:, output:)
    complex_option = ''
    inputs.times do |i|
      complex_option += "[#{i}:0]"
    end
    options = options_line(
      yes: true,
      inputs: inputs,
      output: output,
      filter_complex: "#{complex_option} concat=n=#{inputs.count}:v=0:a=1[out]",
      map: '[out]',
      audio_bitrate: '320k'
    )
    "ffmpeg #{options}"
  end

  def cut_content(input:, begin_time:, end_time:, output:)
    options = options_line(
      yes: true,
      inputs: [input],
      output: output,
      ss: begin_time,
      to: end_time,
      audio_bitrate: '320k',
      copy: :copy
    )
    "ffmpeg #{options}"
  end

  def merge_content(inputs:, output:)
    options = options_line(
      yes: true,
      inputs: inputs,
      output: output,
      filter_complex: 'amix=inputs=2:duration=first:dropout_transition=3'
    )
    "ffmpeg #{options}"
  end

  def use_filters(input:, output:)
    silenceremove = 'silenceremove=stop_periods=-1:stop_duration=1.4:stop_threshold=-30dB'
    acompressor = 'acompressor=threshold=-12dB:ratio=2:attack=200:release=1000'
    volume = 'volume=-0.5dB'

    options = options_line(
      yes: true,
      inputs: [input],
      output: output,
      video_codec: :libx264,
      add_filters: "#{silenceremove},#{acompressor},#{volume}",
      audio_bitrate: '320k'
    )

    "ffmpeg #{options}"
  end

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
    add_filters: 'af'
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
