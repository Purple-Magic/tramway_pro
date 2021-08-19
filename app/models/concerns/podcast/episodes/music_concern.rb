# frozen_string_literal: true

module Podcast::Episodes::MusicConcern
  def add_music(_filename, output)
    raise 'No music for this podcast' unless podcast.musics.any?

    music_output = update_output :music
    command = content_concat(
      inputs: [find_music(:begin)[:path]] + samples + [find_music(:finish)[:path]],
      output: music_output
    )
    Rails.logger.info command
    system command.to_s

    ready_output = update_output :ready
    render_command = merge_content inputs: [music_output, premontage_file.path], output: ready_output
    move_command = move_to(ready_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :with_music
    update_file! output, :premontage_file
    music_add!
  end

  def samples_count
    return @samples_count if @samples_count.present?

    normalized_object = FFMPEG::Movie.new premontage_file.path
    samples_duration = normalized_object.duration - find_music(:begin)[:duration] - find_music(:finish)[:duration]
    @samples_count = (samples_duration / find_music(:sample)[:duration]).round
  end

  def samples
    (1..samples_count).to_a.map do
      @samples_music.present? ? @samples_music : @sample_music = find_music(:sample)[:path]
    end
  end

  def find_music(music_type)
    path = podcast.musics.where(music_type: music_type).first.file.path
    {
      path: path,
      duration: FFMPEG::Movie.new(path).duration
    }
  end

  def update_output(suffix)
    (output.split('.')[0..-2] + [suffix, :mp3]).join('.')
  end
end
