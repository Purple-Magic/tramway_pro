module Podcast::Episodes::FinishConcern
  def concat_trailer_and_episode(output)
    if trailer.present?
      render_command = write_logs content_concat(inputs: [trailer.path, premontage_file.path], output: output)
      Rails.logger.info render_command
      _log, _err, _status = Open3.capture3({}, render_command, {})

      if !status.success? && err.present?
        log_error(err) 
      end
      update_file! output, :ready_file
    else
      update_file! premontage_file.path, :ready_file
    end
    make_audio_ready!
  end
end
