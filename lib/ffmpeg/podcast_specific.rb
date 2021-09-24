# frozen_string_literal: true

module Ffmpeg::PodcastSpecific
  NORMALIZATION_FILTER = 'dynaudnorm=p=0.8:m=100:s=12:g=15'

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
end
