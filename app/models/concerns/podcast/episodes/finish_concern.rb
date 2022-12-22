module Podcast::Episodes::FinishConcern
  def concat_trailer_and_episode(output)
    if trailer.present?
      temp_output = update_output :temp, output

      render_command = write_logs content_concat(inputs: [trailer.path, premontage_file.path], output: temp_output)
      move_command = move_to(temp_output, output)
      command = "#{render_command} && #{move_command}"
      Rails.logger.info command
      _log, _err, _status = Open3.capture3({}, command, {})
      update_file! output, :ready_file
    else
      update_file! premontage_file.path, :ready_file
    end
    make_audio_ready!
  end
end
