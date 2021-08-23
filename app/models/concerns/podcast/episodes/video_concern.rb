# frozen_string_literal: true

module Podcast::Episodes::VideoConcern
  include BotTelegram::Leopold::Notify

  def render_video_trailer(output)
    unless cover.present?
      message = 'You should add episode cover' 
      send_notification_to_user :kalashnikovisme, message
      raise message
    end

    video_temp_output = (output.split('.')[0..-2] + %w[temp mp4]).join('.')

    render_command = write_logs render_video_from(cover.path, trailer.path, output: video_temp_output)
    move_command = move_to(video_temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :video_trailer
    update_file! output, :trailer_video
    make_video_trailer_ready!
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
    command = write_logs "ffmpeg #{options}"
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :full_video
    update_file! output, :full_video
    finish!
  end
end
