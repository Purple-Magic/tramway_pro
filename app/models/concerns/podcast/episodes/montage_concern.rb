# frozen_string_literal: true

module Podcast::Episodes::MontageConcern
  def montage(filename, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')
    render_command = use_filters(input: filename, output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end
end
