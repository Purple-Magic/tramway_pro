# frozen_string_literal: true

module Podcasts::Episodes::FilesManagement
  def remove_files(*files)
    files.each do |file|
      File.delete file
    end
  end
end
