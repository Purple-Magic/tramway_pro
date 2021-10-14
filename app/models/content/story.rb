# frozen_string_literal: true

class Content::Story < ApplicationRecord
  uploader :original_file, :file
  uploader :story, :file

  aasm :converting_state do
    state :ready, initial: true
    state :converting
    state :done

    event :convert do
      transitions to: :converting

      after do
        save!
        ContentStoriesWorker.perform_async id
      end
    end

    event :make_done do
      transitions to: :done
    end
  end

  def render
    output = (original_file.path.split('.')[0..-2] + %w[story mp4]).join('.')
    video_temp_output = (output.split('.')[0..-2] + %w[temp mp4]).join('.')
    command = render_command output, video_temp_output
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :story
    File.open(output) do |std_file|
      public_send 'story=', std_file
    end
    save!
  end

  def render_command(output, video_temp_output)
    ffmpeg_render_command = write_logs "ffmpeg #{options_line(
      inputs: [original_file.path],
      output: video_temp_output,
      ss: begin_time,
      to: end_time,
      video_filter: '"crop=607:1080:600:0"'
    )}"
    move_command = move_to(video_temp_output, output)
    "#{ffmpeg_render_command} && #{move_command}"
  end

  def options_for_notification
    {
      name: story.story.file.filename,
      file_url: story.story.url
    }
  end
end
