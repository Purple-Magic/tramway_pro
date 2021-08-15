# frozen_string_literal: true

require 'fileutils'

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit file_url duration].freeze

  belongs_to :podcast, class_name: 'Podcast'
  has_many :highlights, -> { order(:time) }, class_name: 'Podcast::Highlight'

  uploader :ready_file, :file
  uploader :file, :file
  uploader :cover, :photo
  uploader :premontage_file, :file
  uploader :trailer, :file
  uploader :trailer_video, :file
  uploader :full_video, :file

  aasm :montage, column: :montage_state do
    state :recording, initial: true
    state :recorded
    state :downloaded
    state :converted
    state :prepared
    state :highlighted
    state :montaged
    state :normalized
    state :music_added
    state :trailer_is_ready
    state :trailer_rendered
    state :concatination_in_progress
    state :finishing
    state :ready_audio
    state :video_trailer_is_ready
    state :finished

    event :download do
      transitions to: :downloaded
    end

    event :convert do
      transitions to: :converted
    end

    event :highlight_it do
      transitions to: :highlighted
    end

    event :finish_record do
      transitions to: :recorded

      after do
        save!
        Podcasts::MontageWorker.perform_async id
      end
    end

    event :prepare do
      transitions to: :prepared
    end

    event :to_montage do
      transitions to: :montaged
    end

    event :to_normalize do
      transitions to: :normalized
    end

    event :music_add do
      transitions to: :music_added
    end

    event :trailer_get_ready do
      transitions to: :trailer_is_ready

      after do
        save!
        Podcasts::TrailerWorker.perform_async id
      end
    end

    event :trailer_finish do
      transitions to: :trailer_rendered
    end

    event :make_audio_ready do
      transitions to: :ready_audio
    end

    event :finish do
      transitions to: :finishing

      after do
        save!
        Podcasts::FinishWorker.perform_async id
      end
    end

    event :make_video_trailer_ready do
      transitions to: :video_trailer_is_ready
    end

    event :done do
      transitions to: :finished
    end
  end

  def cut_highlights
    filename = convert_file

    directory = prepare_directory

    highlights.each_with_index do |highlight, index|
      hour = highlight.time.split(':')[0]
      minutes = highlight.time.split(':')[1]
      seconds = highlight.time.split(':')[2]

      highlight_time = DateTime.new(2020, 0o1, 0o1, hour.to_i, minutes.to_i, seconds.to_i)
      begin_time = (highlight_time - 60.seconds).strftime '%H:%M:%S'
      end_time = (highlight_time + 30.seconds).strftime '%H:%M:%S'
      output = "#{directory}/part-#{index + 1}.mp3"
      # TODO: use lib/ffmpeg/builder.rb
      command = "ffmpeg -y -i #{filename} -ss #{begin_time} -to #{end_time} -b:a 320k -c copy #{output} 2> #{parts_directory_name}/cut_highlights-output.txt"
      Rails.logger.info command
      system command
      File.open(output) do |f|
        highlight.file = f
      end
      highlight.save!
    end
  end

  include Podcast::EpisodeConcern

  def raw_description
    recursively_build_description Nokogiri::HTML(description).elements
  end

  def parts_directory_name
    "#{current_podcast_directory}/#{number}/"
  end

  def prepare_directory
    FileUtils.mkdir_p podcasts_directory

    FileUtils.mkdir_p current_podcast_directory
    parts_directory_name.tap do |dir|
      FileUtils.mkdir_p dir
    end
  end

  include Ffmpeg::CommandBuilder

  def montage(filename, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')
    render_command = use_filters(
      input: filename,
      output: temp_output
    )
    render_command = use_filters(input: filename, output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def add_music(_filename, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')
    raise 'No music for this podcast' unless podcast.musics.any?

    normalized_object = FFMPEG::Movie.new premontage_file.path
    samples_duration = normalized_object.duration - find_music(:begin)[:duration] - find_music(:finish)[:duration]
    samples_count = (samples_duration / find_music(:sample)[:duration]).round

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

  def find_music(music_type)
    path = podcast.musics.where(music_type: music_type).first.file.path
    {
      path: path,
      duration: FFMPEG::Movie.new(path).duration
    }
  end

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

  def concat_trailer_and_episode(output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    render_command = content_concat inputs: [trailer.path, premontage_file.path], output: temp_output
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def render_video_trailer(output)
    raise 'You should add episode cover' unless cover.present?

    video_temp_output = (output.split('.')[0..-2] + %w[temp mp4]).join('.')

    render_command = render_video_from(cover.path, trailer.path, output: video_temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def move_to(temp_output, output)
    "mv #{temp_output} #{output}"
  end

  def render_full_video(output)
    inputs = [cover.path, ready_file.path]
    options = options_line(
      inputs: inputs,
      output: output,
      yes: true,
      loop_value: 1,
      video_codec: :libx264,
      tune: :stillimage,
      audio_codec: :aac,
      bitrate_audio: '192k',
      pixel_format: 'yuv420p',
      shortest: true,
      strict: 2
    )
    command = "ffmpeg #{options} 2> #{parts_directory_name}/video_render.txt"
    Rails.logger.info command
    system command
  end

  def converted_file
    file.path.split('.')[0..].join('.')
  end

  def convert_file
    filename = converted_file

    if file.path.split('.').last == 'ogg'
      filename += '.mp3'
      command = convert_to :mp3, input: file.path, output: filename
      Rails.logger.info command
      system command
    end

    filename
  end

  def update_file!(output, file_type)
    File.open(output) do |f|
      send "#{file_type}=", f
    end
    save!
  end

  private

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
      move_command = move_to(temp_output, output)
      command = "#{render_command} && #{move_command}"
      Rails.logger.info command
      system command

      wait_for_file_rendered highlight_output, "Highlight #{highlight.id}"

      update_file! highlight_output, :ready_file
    end
  end

  def podcasts_directory
    "/#{Rails.root}/public/podcasts/"
  end

  def current_podcast_directory
    "#{podcasts_directory}#{podcast.title.gsub(' ', '_')}/"
  end
end
