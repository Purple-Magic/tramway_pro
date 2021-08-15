# frozen_string_literal: true

module Podcast::Episodes::MusicConcern
  def add_music(_filename, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')
    raise 'No music for this podcast' unless podcast.musics.any?

    render_command = content_concat(
      inputs: [find_music(:begin)[:path]] + samples_count.map { sample_music } + [find_music(:finish)[:path]],
      output: temp_output
    )
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command.to_s

    ready_output = (output.split('.')[0..-2] + %w[ready mp3]).join('.')
    render_command = merge_content inputs: [temp_output, premontage_file.path], output: ready_output
    move_command = move_to(temp_output, output)
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
