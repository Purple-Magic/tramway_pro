# frozen_string_literal: true

module Podcast::Episodes::TrailerConcern
  def build_trailer
    output = "#{prepare_directory.gsub('//', '/')}/trailer.mp3"
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    trailer_separator = podcast.musics.where(music_type: :trailer_separator).first.file.path
    using_highlights = highlights.where(using_state: :using).order(:trailer_position)
    raise 'You should pick some highlights as using' unless using_highlights.any?

    cut_using_highlights using_highlights, output

    inputs = using_highlights.map do |highlight|
      [highlight.ready_file.path, trailer_separator]
    end.flatten

    render_command = content_concat inputs: inputs, output: temp_output
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"

    Rails.logger.info command
    system command

    wait_for_file_rendered output, :trailer
    update_file! output, :trailer
    trailer_finish!
  end

  def cut_using_highlights(using_highlights, output)
    directory = output.split('/')[0..-2].join('/')
    using_highlights.each do |highlight|
      highlight.cut directory
    end
  end

  def concat_trailer_and_episode(output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    render_command = content_concat inputs: [trailer.path, premontage_file.path], output: temp_output
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :trailer
    update_file! output, :ready_file
    make_audio_ready!
  end
end
