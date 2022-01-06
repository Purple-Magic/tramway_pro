# frozen_string_literal: true

module Video::UploadConcern
  def upload(path, remote_path)
    command = "scp #{path} #{remote_path}"
    Rails.logger.info command
    system command
  end
end
