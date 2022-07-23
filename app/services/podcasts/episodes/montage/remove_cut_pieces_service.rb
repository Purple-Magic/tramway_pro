# frozen_string_literal: true

class Podcasts::Episodes::Montage::RemoveCutPiecesService < Podcasts::Episodes::BaseService
  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end

  def call
    slice
    concat_slices
  end

  private

  def slice
    times.each_slice(2).with_index do |(begin_time, end_time), index|
      output = "#{episode.prepare_directory}/slice-#{index + 1}.mp3"

      render_command = write_logs(cut_content(
        input: "#{episode.converted_file}.mp3",
        output: output,
        begin_time: begin_time,
        end_time: end_time
      ))

      run render_command, output: output, name: "Slice #{index}", action: 'Remove cut pieces'
    end
  end

  def concat_slices
    inputs = (1..(times.count / 2) + (times.count % 2)).to_a.map do |index|
      "#{episode.prepare_directory}/slice-#{index}.mp3"
    end
    output = "#{episode.prepare_directory}/remove_cut_pieces.mp3"

    render_command = write_logs content_concat(
      inputs: inputs,
      output: output
    )

    run render_command, output: output, name: 'RemoveCutPieces', action: 'Concat cut pieces slices'
    episode.update_file! output, :premontage_file

    remove_files(*inputs, output)
  end

  def times
    ['00:00'] + episode.parts.map do |part|
      [part.begin_time, part.end_time]
    end.flatten
  end
end
