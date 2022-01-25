# frozen_string_literal: true

class Podcast::Highlight < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  scope :podcast_scope, ->(_user_id) { all }

  enumerize :using_state, in: %i[using not_using], default: :not_using

  uploader :file, :file
  uploader :ready_file, :file
  uploader :instagram_story, :file

  validate :time_format

  include Podcast::SoundProcessConcern
  include Podcasts::Episodes::TimeManagement
  include Ffmpeg::CommandBuilder

  def cut(output)
    raise "You should pick begin and end time for Highlight #{id}" if !cut_begin_time.present? && !cut_end_time.present?

    directory = output.split('/')[0..-2].join('/')
    highlight_output = "#{directory}/#{id}.mp3"
    render_command = write_logs cut_content(
      input: file.path,
      begin_time: cut_begin_time,
      end_time: cut_end_time,
      output: highlight_output
    )
    command = render_command
    Rails.logger.info command
    system command

    wait_for_file_rendered highlight_output, "Highlight #{id}"

    update_file! highlight_output, :ready_file
  end

  def cut_from_whole_file(filename, index)
    output = "#{directory}/part-#{index + 1}.mp3"
    build_and_run_command(input: filename, begin_time: begin_time, end_time: end_time, output: output)
    wait_for_file_rendered output, "Highlight #{id}"
    update_file! output, :file
  end

  def render_instagram_story
    # output = "#{directory}/story-#{index + 1}.mp4"
  end

  def directory
    @directory ||= episode.prepare_directory
  end

  def minute
    time.split(':')[1].to_i
  end

  def second
    time.split(':')[2].to_i
  end

  def begin_time
    change_time(time, :minus, 60.seconds)
  end

  def end_time
    change_time(time, :plus, 30.seconds)
  end

  def shift
    episode.parts.sum do |part|
      #if time_less_than highlight.begin_time
    end
  end

  private

  def build_and_run_command(**options)
    command = write_logs cut_content(**options)
    Rails.logger.info command
    system command
  end

  def time_format
    return if time.match(/\d\d:\d\d:\d\d/) && minute < 60 && second < 60

    errors.add(:time, 'invalid')
  end
end
