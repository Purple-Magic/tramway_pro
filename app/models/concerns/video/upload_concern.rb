# frozen_string_literal: true

module Video::UploadConcern
  def upload(path, remote_path)
    command = "scp #{path} #{remote_path}"
    log_command 'Render video on remote server', command
    Rails.logger.info command
    system command
  end
end
