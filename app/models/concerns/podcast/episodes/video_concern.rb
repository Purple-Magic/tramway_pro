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
    ::Shortener::ShortenedUrl.generate(trailer_video.url, owner: self)
    make_video_trailer_ready!
  end

  def render_full_video(output)
    cover_filename = "#{REMOTE_PATH}#{id}/#{cover.path.split('/').last}"
    ready_filename = "#{REMOTE_PATH}#{id}/#{ready_file.path.split('/').last}"
    output_filename = "#{REMOTE_PATH}#{id}/#{output.split('/').last}"
    inputs = [cover_filename, ready_filename]
    options = options_line(
      inputs: inputs,
      output: output_filename,
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
    run_render_on_remote_server [cover.path, ready_file.path]
    send_request_after_render_command = "curl -X PATCH red-magic.ru/red_magic/api/v1/podcast/episodes/#{id}/video_is_ready"
    command = "nohup /bin/bash -c 'ffmpeg #{options} && #{send_request_after_render_command}' &"
    Rails.logger.info "#{command}"
    run_command_on_remote_server command
  end

  def download_video_from_remote_host!
    path = "#{parts_directory_name}/full_video.mp4"
    command = "scp #{REMOTE_USER}@#{REMOTE_SERVER}:#{REMOTE_PATH}#{id}/full_video.mp4 #{path}"
    Rails.logger.info command
    system command
    update_file! path, :full_video
  end

  private

  def send_cover_error_notification
    message = I18n.t('podcast_engine.notifications.video_trailer.you_need_to_episode_cover')
    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, message
    raise message
  end

  REMOTE_SERVER = "82.148.30.250"
  REMOTE_USER = "root"
  REMOTE_PATH = "/root/podcast_engine/"

  def run_command_on_remote_server(remote_command)
    command = "ssh -t #{REMOTE_USER}@#{REMOTE_SERVER} '#{remote_command}'"
    Rails.logger.info command
    system command
  end
  
  def run_render_on_remote_server(inputs)
    run_command_on_remote_server "mkdir podcast_engine/#{id}" 

    inputs.each do |input|
      command = "scp #{input} #{REMOTE_USER}@#{REMOTE_SERVER}:#{REMOTE_PATH}#{id}/"
      Rails.logger.info command
      system command
    end
  end
end
