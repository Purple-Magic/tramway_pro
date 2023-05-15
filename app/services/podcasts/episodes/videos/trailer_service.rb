class Podcasts::Episodes::Videos::TrailerService < Podcasts::Episodes::BaseService
  def call
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
end
