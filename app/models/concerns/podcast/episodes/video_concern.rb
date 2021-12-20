# frozen_string_literal: true

require 'net/scp'

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
    inputs = [cover.filename, ready_file.filename]
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
    run_render_on_remote_server [cover.path, ready_file.path]
    command = "cd podcast_engine && ffmpeg #{options}"
    Rails.logger.info "#{command}"
    run_command_on_remote_server command
    # It's saving async
    #wait_for_file_rendered output, :full_video
    #update_file! output, :full_video
    finish!
  end

  private

  def send_cover_error_notification
    message = I18n.t('podcast_engine.notifications.video_trailer.you_need_to_episode_cover')
    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, message
    raise message
  end

  REMOTE_SERVER = "167.71.46.15"
  REMOTE_USER = "root"

  def run_command_on_remote_server(remote_command)
    command = "ssh -t #{REMOTE_USER}@#{REMOTE_SERVER} '#{remote_command}'"
    Rails.logger.info command
    system command
  end
  
  def run_render_on_remote_server(inputs, render_command)
    run_command_on_remote_server "mkdir podcast_engine/#{id}" 

    inputs.each do |input|
      command = "scp #{input} #{REMOTE_USER}@#{REMOTE_SERVER}:/root/podcast_engine/#{id}/"
      Rails.logger.info command
      system command
    end
  end
end
