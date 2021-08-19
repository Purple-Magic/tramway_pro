# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Worker
  include ExtendedLogger

  def wait_for_file_rendered(output, file_type)
    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "#{file_type} file does not exist for #{index} seconds"
    end
  end
end
