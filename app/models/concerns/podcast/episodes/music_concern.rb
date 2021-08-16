# frozen_string_literal: true

module Podcast::Episodes::MusicConcern
  def add_music(_filename, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')
    raise 'No music for this podcast' unless podcast.musics.any?

    samples = (1..samples_count).to_a.map do
      @sample_music ||= find_music(:sample)[:path]
    end
    music_output = (output.split('.')[0..-2] + %w[music mp3]).join('.')
    command = content_concat(
      inputs: [find_music(:begin)[:path]] + samples + [find_music(:finish)[:path]],
      output: music_output
    )
    Rails.logger.info command
    system command.to_s

    ready_output = (output.split('.')[0..-2] + %w[ready mp3]).join('.')
    render_command = merge_content inputs: [music_output, premontage_file.path], output: ready_output
    move_command = move_to(ready_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def samples_count
    return @samples_count if @samples_count.present?

    normalized_object = FFMPEG::Movie.new premontage_file.path
    samples_duration = normalized_object.duration - find_music(:begin)[:duration] - find_music(:finish)[:duration]
    @samples_count = (samples_duration / find_music(:sample)[:duration]).round
  end

  def find_music(music_type)
    path = podcast.musics.where(music_type: music_type).first.file.path
    {
      path: path,
      duration: FFMPEG::Movie.new(path).duration
    }
  end
end
