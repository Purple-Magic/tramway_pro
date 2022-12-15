# frozen_string_literal: true

module Ffmpeg::Base
  CODECS = {
    mp3: :libmp3lame
  }.freeze

  # :reek:UtilityFunction { enabled: false }
  def convert_to(format, input:, output:)
    "ffmpeg -y -i #{input} -b:a 192k -c:a #{CODECS[format]} #{output}"
  end
  # :reek:UtilityFunction { enabled: true }

  def render_video_from(image, sound, output:)
    options = options_line(yes: true, loop_value: 1, inputs: [image, sound], video_codec: :libx264, tune: :stillimage,
      audio_codec: :aac, audio_bitrate: '192k', pixel_format: :yuv420p, shortest: true, output: output)
    "ffmpeg #{options}"
  end

  def content_concat(inputs:, output:)
    complex_option = ''
    count = inputs.count
    count.times { |index| complex_option += "[#{index}:0]" }
    options = options_line(
      yes: true,
      inputs: inputs,
      output: output,
      filter_complex: "'#{complex_option} concat=n=#{count}:v=0:a=1[out]'",
      map: '\'[out]\'',
      audio_bitrate: '192k'
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
      audio_bitrate: '192k',
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
end
