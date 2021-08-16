# frozen_string_literal: true

module Podcast::Episodes::TrailerConcern
  def build_trailer(output)
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
  end

  def cut_using_highlights(using_highlights, output)
    directory = output.split('/')[0..-2].join('/')
    using_highlights.each do |highlight|
      if !highlight.cut_begin_time.present? && !highlight.cut_end_time.present?
        raise "You should pick begin and end time for Highlight #{highlight.id}"
      end

      highlight_output = "#{directory}/#{highlight.id}.mp3"
      render_command = cut_content(
        input: highlight.file.path,
        begin_time: highlight.cut_begin_time,
        end_time: highlight.cut_end_time,
        output: highlight_output
      )
      command = render_command
      Rails.logger.info command
      system command

      wait_for_file_rendered highlight_output, "Highlight #{highlight.id}"

      update_file! highlight_output, :ready_file
    end
  end

  def concat_trailer_and_episode(output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    render_command = content_concat inputs: [trailer.path, premontage_file.path], output: temp_output
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def wait_for_file_rendered(output, file_type)
    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "#{file_type} file does not exist for #{index} seconds"
    end
  end
end
