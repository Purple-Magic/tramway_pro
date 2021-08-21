# frozen_string_literal: true

module Podcast::Episodes::MontageConcern
  def montage(_filename)
    directory = prepare_directory.gsub('//', '/')
    output = "#{directory}/montage.mp3"
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    build_and_run_command output, temp_output

    wait_for_file_rendered output, :montage
    update_file! output, :premontage_file
    prepare!
  end

  private

  def build_and_run_command(output, temp_output)
    render_command = use_filters(input: filename, output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end
end
