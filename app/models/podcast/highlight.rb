# frozen_string_literal: true

class Podcast::Highlight < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  scope :podcast_scope, ->(_user_id) { all }

  enumerize :using_state, in: %i[using not_using], default: :not_using

  uploader :file, :file
  uploader :ready_file, :file

  include Podcast::SoundProcessConcern
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
    directory = episode.prepare_directory

    hour, minutes, seconds = time.split(':')
    highlight_time = DateTime.new(2020, 0o1, 0o1, hour.to_i, minutes.to_i, seconds.to_i)
    begin_time = compute_begin_time highlight_time 
    end_time = (highlight_time + 30.seconds).strftime '%H:%M:%S'
    output = "#{directory}/part-#{index + 1}.mp3"
    build_and_run_command(input: filename, begin_time: begin_time, end_time: end_time, output: output)
    wait_for_file_rendered output, "Highlight #{id}"
    update_file! output, :file
  end

  private

  def build_and_run_command(**options)
    command = write_logs cut_content(**options)
    Rails.logger.info command
    system command
  end

  def compute_begin_time(highlight_time)
    if highlight_time > DataTime.new(2020, 1, 1, 0, 1, 0)
      (highlight_time - 60.seconds).strftime '%H:%M:%S'
    else
      ""
    end
  end
end
