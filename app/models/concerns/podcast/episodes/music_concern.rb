# frozen_string_literal: true

module Podcast::Episodes::MusicConcern
  def add_music(output)
    raise 'No music for this podcast' unless podcast.musics.any?

    music_output = update_output :music, output
    render_whole_length_samples music_output
    merge_samples_with_voices music_output, output
    concat_with_beginning_and_ending output

    music_add!
  end

  private

  def samples_count
    return @samples_count if @samples_count.present?

    normalized_object = FFMPEG::Movie.new premontage_file.path
    @samples_count = (normalized_object.duration / find_music(:sample)[:duration]).round
  end

  def samples
    @sample_music = find_music(:sample)[:path]

    (1..samples_count).to_a.map do
      @sample_music 
    end
  end

  def find_music(music_type)
    path = podcast.musics.where(music_type: music_type).first&.file&.path
    if path.present?
      { path: path, duration: FFMPEG::Movie.new(path).duration }
    else
      { duration: 0 }
    end
  end

  def render_whole_length_samples(music_output)
    command = write_logs content_concat(
      inputs: samples,
      output: music_output
    )
    log_command 'Render whole length samples', command
    Rails.logger.info command
    system command.to_s
  end

  def merge_samples_with_voices(music_output, output)
    ready_output = update_output :ready, output
    render_command = write_logs merge_content(inputs: [music_output, premontage_file.path], output: ready_output)
    move_command = move_to(ready_output, output)
    command = "#{render_command} && #{move_command}"
    log_command 'Merge music with voices', command
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :with_music
    update_file! output, :premontage_file
  end

  def concat_with_beginning_and_ending(output)
    ready_output = update_output :ready, output
    render_command = write_logs content_concat(
      inputs: [find_music(:begin)[:path], output, find_music(:finish)[:path]].compact,
      output: ready_output
    )
    move_command = move_to(ready_output, output)
    command = "#{render_command} && #{move_command}"
    log_command 'Concat with beginning and ending', command
    Rails.logger.info command
    system command.to_s
    wait_for_file_rendered output, :with_music
    update_file! output, :premontage_file
  end
end
