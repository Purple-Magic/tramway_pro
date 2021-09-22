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
    inputs.count.times { |index| complex_option += "[#{index}:0]" }
    options = options_line(
      yes: true,
      inputs: inputs,
      output: output,
      filter_complex: "'#{complex_option} concat=n=#{inputs.count}:v=0:a=1[out]'",
      map: '\'[out]\'',
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

  NORMALIZATION_FILTER = "dynaudnorm=p=0.9:m=100:s=12:g=15"

  def normalize(input:, output:)
    options = options_line(
      yes: true,
      inputs: [input],
      output: output,
      add_filters: "\"#{NORMALIZATION_FILTER}\""
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
      add_filters: "\"#{silenceremove},#{acompressor},#{volume},#{NORMALIZATION_FILTER}\"",
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
