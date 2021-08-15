# frozen_string_literal: true

module Podcast::Episodes::HighlightsConcern
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
      command = cut_content(input: filename, begin_time: begin_time, end_time: end_time, output: output)
      Rails.logger.info command
      system command
      File.open(output) do |f|
        highlight.file = f
      end
      highlight.save!
    end
  end
end
