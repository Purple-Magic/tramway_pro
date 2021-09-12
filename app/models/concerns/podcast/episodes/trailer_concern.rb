# frozen_string_literal: true

module Podcast::Episodes::TrailerConcern
  def build_trailer
    output = "#{prepare_directory.gsub('//', '/')}/trailer.mp3"

    cut_using_highlights

    temp_output = update_output :temp, output
    render_command = write_logs(content_concat(inputs: content, output: temp_output))
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    system command

    wait_for_file_rendered output, :trailer
    update_file! output, :trailer
    trailer_finish!
  end

  def concat_trailer_and_episode(output)
    temp_output = update_output :temp, output

    render_command = write_logs content_concat(inputs: [trailer.path, premontage_file.path], output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :trailer
    update_file! output, :ready_file
    make_audio_ready!
  end

  private

  def using_highlights
    @collection ||= highlights.where(using_state: :using).order(:trailer_position)
    @collection.tap do
      raise 'You should pick some highlights as using' unless @collection.any?
    end
  end

  def cut_using_highlights
    using_highlights.each do |highlight|
      highlight.cut output
    end
  end

  def files_inputs(using_highlights)
    trailer_separator = podcast.musics.where(music_type: :trailer_separator).first.file.path
    @files_inputs ||= using_highlights.map do |highlight|
      [highlight.ready_file.path, trailer_separator]
    end.flatten
  end

  def build_and_runcommand(files_inputs, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    render_command = content_concat inputs: files_inputs, output: temp_output
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def content
    trailer_separator = podcast.musics.where(music_type: :trailer_separator).first
    using_highlights.sort_by(&:trailer_position).map do |content_file|
      [content_file.ready_file.path, trailer_separator.file.path]
    end.flatten
  end
end
