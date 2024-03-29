# frozen_string_literal: true

module Podcast::Episodes::VideoConcern
  include BotTelegram::Leopold::Notify
  include Video::UploadConcern

  def render_video_trailer_action(output, remote: true)
    send_cover_error_notification unless cover.present?

    remote_output = remote_file_name output

    send_files_to_remote_server [cover.path, trailer.path]
    render_command = render_video_from(
      remote_file_name(cover.path),
      remote_file_name(trailer.path),
      output: remote_output
    )
    command = "nohup /bin/bash -lic '#{render_command} && #{send_request_after_render_command(id, :trailer_video)}' &"
    run_command_on_remote_server command
  end

  def render_story_video_trailer_action(output)
    remote_output = remote_file_name output

    send_files_to_remote_server [story_cover.path, trailer.path]
    render_command = render_video_from(
      remote_file_name(story_cover.path),
      remote_file_name(trailer.path),
      output: remote_output
    )
    run_command_on_remote_server command
  end

  def render_full_video(output)
    options = options_line(
      inputs: [cover.path, ready_file.path],
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
    command = "ffmpeg #{options}"
    Rails.logger.info command.to_s
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

  def run_command_on_remote_server(command)
    log_command 'Render video on remote server', command
    Rails.logger.info command

    # make the POST request
    response = conn.post do |req|
      req.url "#{REMOTE_SERVER}:8080"
      req.headers['Content-Type'] = 'application/json'
      req.body = { command: }.to_json
    end

    # handle the response
    if response.success?
      puts "Request succeeded with status #{response.status}"
      puts "Response body: #{response.body}"
    else
      puts "Request failed with status #{response.status}"
    end
  end

  def send_files_to_remote_server(inputs)
    run_command_on_remote_server "mkdir podcast_engine/#{id}"

    inputs.each do |input|
      upload input, "#{REMOTE_USER}@#{REMOTE_SERVER}:#{REMOTE_PATH}#{id}/"
    end
  end

  def remote_file_name(path)
    "#{REMOTE_PATH}#{id}/#{path.split('/').last}"
  end

  def send_request_after_render_command(id, video_type)
    "curl -X PATCH red-magic.ru/red_magic/api/v1/podcast/episodes/#{id}/video_is_ready?video_type=#{video_type}"
  end
end
