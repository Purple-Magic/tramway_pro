# frozen_string_literal: true

class Podcasts::Episodes::Parts::GeneratePreviewService < Podcasts::Episodes::BaseService
  attr_reader :part

  def initialize(part)
    @part = part
  end

  def call
    before_file_data = cut_part direction: :before
    after_file_data = cut_part direction: :after
    concat_preview_data = concat_parts before: before_file_data[:output], after: after_file_data[:output]

    Podcasts::Episodes::Parts::PreviewWorker.perform_async(
      part.id,
      concat_preview_data[:output],
      before_file_data[:render_command],
      after_file_data[:render_command],
      concat_preview_data[:render_command]
    )
  end

  private

  def concat_parts(before:, after:)
    output = build_output(object: part, attribute: :preview, suffix: :concated_parts)
    render_command = write_logs content_concat inputs: [before, after], output: output
    {
      output: output,
      render_command: render_command
    }
  end

  def cut_part(direction:)
    times = calc_times direction: direction
    output = build_output(object: part, attribute: :preview, suffix: direction)
    options = {
      input: "#{part.episode.converted_file}.mp3",
      begin_time: times[:begin_time],
      end_time: times[:end_time],
      output: output
    }
    render_command = write_logs cut_content(**options)

    {
      output: output,
      render_command: render_command
    }
  end

  def calc_times(direction:)
    case direction
    when :before
      {
        begin_time: change_time(part.begin_time, :minus, 10.seconds),
        end_time: change_time(part.begin_time)
      }
    when :after
      {
        begin_time: change_time(part.end_time),
        end_time: change_time(part.end_time, :plus, 10.seconds)
      }
    end
  end
end
