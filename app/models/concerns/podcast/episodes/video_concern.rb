# frozen_string_literal: true

module Podcast::Episodes::VideoConcern
  include BotTelegram::Leopold::Notify

  def render_video_trailer_action(output)
    send_cover_error_notification unless cover.present?

    remote_output = remote_file_name output
    video_temp_output = (remote_output.split('.')[0..-2] + %w[temp mp4]).join('.')

    send_files_to_remote_server [cover.path, trailer.path]
    render_command = render_video_from(
      remote_file_name(cover.path),
      remote_file_name(trailer.path),
      output: video_temp_output
    )
    move_command = move_to(video_temp_output, remote_output)
    command = "#{render_command} && #{move_command}"
    send_request_after_render_command = "curl -X PATCH red-magic.ru/red_magic/api/v1/podcast/episodes/#{id}/video_is_ready?video_type=trailer_video"
    command = "nohup /bin/bash -c '#{command} && #{send_request_after_render_command}' &"
    run_command_on_remote_server command
  end

  def render_full_video(output)
    inputs = [remote_file_name(cover.path), remote_file_name(ready_file.path)]
    options = options_line(
      inputs: inputs,
      output: remote_file_name(output),
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
    command = "ffmpeg #{options}"
    send_files_to_remote_server [cover.path, ready_file.path]
    send_request_after_render_command = "curl -X PATCH red-magic.ru/red_magic/api/v1/podcast/episodes/#{id}/video_is_ready?video_type=full_video"
    command = "nohup /bin/bash -c '#{command} && #{send_request_after_render_command}' &"
    Rails.logger.info command.to_s
    run_command_on_remote_server command
  end

  def download_video_from_remote_host!(video_type)
    path = "#{parts_directory_name}/#{video_type}.mp4"
    command = "scp #{REMOTE_USER}@#{REMOTE_SERVER}:#{REMOTE_PATH}#{id}/#{video_type}.mp4 #{path}"
    Rails.logger.info command
    system command
    update_file! path, video_type
  end

  private

  def send_cover_error_notification
    message = I18n.t('podcast_engine.notifications.video_trailer.you_need_to_episode_cover')
    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, message
    raise message
  end

  REMOTE_SERVER = '82.148.30.250'
  REMOTE_USER = 'root'
  REMOTE_PATH = '/root/podcast_engine/'

  def run_command_on_remote_server(remote_command)
    command = "ssh #{REMOTE_USER}@#{REMOTE_SERVER} \"#{remote_command}\""
    Rails.logger.info command
    system command
  end

  def send_files_to_remote_server(inputs)
    run_command_on_remote_server "mkdir podcast_engine/#{id}"

    inputs.each do |input|
      command = "scp #{input} #{REMOTE_USER}@#{REMOTE_SERVER}:#{REMOTE_PATH}#{id}/"
      Rails.logger.info command
      system command
    end
  end

  def remote_file_name(path)
    "#{REMOTE_PATH}#{id}/#{path.split('/').last}"
  end
end
