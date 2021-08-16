# frozen_string_literal: true

module Podcast::Episodes::VideoConcern
  def render_video_trailer(output)
    raise 'You should add episode cover' unless cover.present?

    video_temp_output = (output.split('.')[0..-2] + %w[temp mp4]).join('.')

    render_command = render_video_from(cover.path, trailer.path, output: video_temp_output)
    move_command = move_to(video_temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def render_full_video(output)
    inputs = [cover.path, ready_file.path]
    options = options_line(
      inputs: inputs,
      output: output,
      yes: true,
      loop_value: 1,
      video_codec: :libx264,
      tune: :stillimage,
      audio_codec: :aac,
      bitrate_audio: '192k',
      pixel_format: 'yuv420p',
      shortest: true,
      strict: 2
    )
    command = "ffmpeg #{options} 2> #{parts_directory_name}/video_render.txt"
    Rails.logger.info command
    system command
  end
end
