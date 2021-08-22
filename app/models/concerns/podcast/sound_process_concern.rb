# frozen_string_literal: true

module Podcast::SoundProcessConcern
  def update_file!(output, file_type)
    File.open(output) do |std_file|
      public_send "#{file_type}=", std_file
    end
    save!
  end

  def wait_for_file_rendered(output, file_type)
    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      message = "#{file_type} file does not exist for #{index} seconds"
      Rails.logger.info message
    end
  end
end
