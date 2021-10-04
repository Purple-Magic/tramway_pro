class ContentStoriesWorker < ApplicationWorker
  sidekiq_options queue: :content

  include Ffmpeg::CommandBuilder
  include Podcast::SoundProcessConcern
  include BotTelegram::Leopold::Notify

  def perform(id)
    story = Content::Story.find id
    make story
    chat_id = BotTelegram::Leopold::ChatDecorator::STORY_MAKER_ID
    send_notification_to_chat chat_id, notification(:story, :converted, name: story.original_file.file.filename, file_url: story.original_file.url)
  end

  private

  def make(story)
    output = (story.original_file.path.split('.')[0..-2] + %w[story mp4]).join('.')
    video_temp_output = (output.split('.')[0..-2] + %w[temp mp4]).join('.')
    render_command = write_logs "ffmpeg #{options_line(
      inputs: [story.original_file.path],
      output: video_temp_output,
      ss: story.begin_time,
      to: story.end_time,
      video_filter: "\"crop=607:1080:600:0\""
    )}"
    move_command = move_to(video_temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
    wait_for_file_rendered output, :story
    File.open(output) do |std_file|
      story.public_send "story=", std_file
    end
    story.save!
  end
end
