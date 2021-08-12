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
        PodcastsMontageWorker.perform_async self.id
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
        PodcastsTrailerWorker.perform_async self.id
      end
    end

    event :trailer_finish do
      transitions to: :trailer_rendered
    end

    event :finish do
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
      begin_time = (highlight_time - 90.seconds).strftime '%H:%M:%S'
      end_time = (highlight_time + 10.seconds).strftime '%H:%M:%S'
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
    temp_output = (output.split('.')[0..-2] + ["temp", "mp3"]).join('.')
    command = "ffmpeg -y -i #{filename} -vcodec libx264 -af silenceremove=stop_periods=-1:stop_duration=1.4:stop_threshold=-30dB,acompressor=threshold=-12dB:ratio=2:attack=200:release=1000,volume=-0.5dB -b:a 320k #{temp_output} 2> #{parts_directory_name}/montage-output.txt && mv #{temp_output} #{output}"
    Rails.logger.info command
    system command
  end

  def normalize(filename, output)
    temp_output = (output.split('.')[0..-2] + ["temp", "mp3"]).join('.')
    command = "ffmpeg-normalize #{filename} -o #{temp_output} -b:a 320k -c:a libmp3lame -t -8 2> #{parts_directory_name}/normalize-output.txt && mv #{temp_output} #{output}"
    Rails.logger.info command
    system command
  end

  def add_music(filename, output)
    temp_output = (output.split('.')[0..-2] + ["temp", "mp3"]).join('.')
    music_render_command = ''
    raise 'No music for this podcast' unless podcast.musics.any?
    begin_music = podcast.musics.where(music_type: :begin).first.file.path
    begin_music_object = FFMPEG::Movie.new begin_music
    finish_music = podcast.musics.where(music_type: :finish).first.file.path
    finish_music_object = FFMPEG::Movie.new finish_music
    sample_music = podcast.musics.where(music_type: :sample).first.file.path
    sample_music_object = FFMPEG::Movie.new sample_music
    normalized_podcast_object = FFMPEG::Movie.new premontage_file.path
    samples_count = ((normalized_podcast_object.duration - (begin_music_object.duration + finish_music_object.duration)) / sample_music_object.duration).round

    beg = "ffmpeg -y -i #{begin_music}"
    filter = "-filter_complex"
    audios = ''
    samples_count.times do |i|
      audios += "-i #{sample_music} "
    end
    finish = "-i #{finish_music} "
    parts = ""
    (samples_count + 2).times do |i|
      parts += "[#{i}:0]"
    end
    concatination = "concat=n=#{samples_count + 2}:v=0:a=1[out]' -map '[out]' -b:a 320k #{temp_output} 2> #{parts_directory_name}/add_music-output.txt"

    command = "#{beg} #{audios} #{finish} #{filter} '#{parts} #{concatination}"
    Rails.logger.info command
    system "#{command}"
    ready_output = (output.split('.')[0..-2] + ["ready", "mp3"]).join('.')
    system "ffmpeg -y -i #{temp_output} -i #{premontage_file.path} -filter_complex amix=inputs=2:duration=first:dropout_transition=3 #{ready_output} 2> #{parts_directory_name}/merge-music-output.txt"
    system "mv #{ready_output} #{output}" 
  end

  def build_trailer(output)
    temp_output = (output.split('.')[0..-2] + ["temp", "mp3"]).join('.')
    trailer_separator = podcast.musics.where(music_type: :trailer_separator).first.file.path
    using_highlights = highlights.where(using_state: :using).order(:trailer_position)
    raise 'You should pick some highlights as using' unless using_highlights.any?

    directory = output.split('/')[0..-2].join('/')
    using_highlights.each do |highlight|
      raise "You should pick begin and end time for Highlight #{highlight.id}" if !highlight.cut_begin_time.present? && !highlight.cut_end_time.present?
      highlight_output = "#{directory}/#{highlight.id}.mp3"
      command = "ffmpeg -y -i #{highlight.file.path} -ss #{highlight.cut_begin_time} -to #{highlight.cut_end_time} -b:a 320k -c copy #{highlight_output}"
      Rails.logger.info command
      puts command
      system command

      index = 0
      until File.exist?(highlight_output)
        sleep 1
        index += 1
        Rails.logger.info "Highlight ready file #{highlight.id} does not exist for #{index} seconds"
      end

      File.open(highlight_output) do |f|
        highlight.ready_file = f
      end
      highlight.save!
    end

    command = using_highlights.reduce("ffmpeg -y ") do |com, highlight|
      com += "-i #{highlight.ready_file.path} "
      com += "-i #{trailer_separator} "
    end
    command +=  "-filter_complex '"
    (using_highlights.count * 2).times do |i|
      command += "[#{i}:0]"
    end

    command += " concat=n=#{using_highlights.count * 2}:v=0:a=1[out]' -map '[out]' -b:a 320k #{temp_output} 2> #{parts_directory_name}/build_trailer-output.txt"
    Rails.logger.info command
    system "#{command} && mv #{temp_output} #{output}" 
  end

  def converted_file
    filename = file.path.split('.')[0..-1].join('.')
  end

  def convert_file
    filename = converted_file

    if file.path.split('.').last == 'ogg'
      filename += '.mp3'
      command = "ffmpeg -y -i #{file.path} -b:a 320k -c:a libmp3lame #{filename}"
      Rails.logger.info command
      system command
    end

    filename
  end

  private

  def podcasts_directory
    "/#{Rails.root}/public/podcasts/"
  end

  def current_podcast_directory
    "#{podcasts_directory}#{podcast.title.gsub(' ', '_')}/"
  end
end
