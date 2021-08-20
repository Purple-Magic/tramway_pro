# frozen_string_literal: true

class Podcast::Highlight < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  scope :podcast_scope, ->(_user_id) { all }

  enumerize :using_state, in: %i[using not_using], default: :not_using

  uploader :file, :file
  uploader :ready_file, :file

  include Podcast::SoundProcessConcern

  def cut(directory)
    raise "You should pick begin and end time for Highlight #{id}" if !cut_begin_time.present? && !cut_end_time.present?

    highlight_output = "#{directory}/#{id}.mp3"
    render_command = cut_content(
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
end
