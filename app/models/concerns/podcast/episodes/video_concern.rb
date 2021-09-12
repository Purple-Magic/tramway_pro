# frozen_string_literal: true

module Podcast::Episodes::VideoConcern
  include BotTelegram::Leopold::Notify

  def render_video_trailer(output)
    send_cover_error_notification unless cover.present?

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

  private

  def send_cover_error_notification
    message = I18n.t('podcast_engine.notifications.video_trailer.you_need_to_episode_cover')
    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, message
    raise message
  end
end
