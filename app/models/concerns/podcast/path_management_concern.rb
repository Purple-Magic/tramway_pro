# frozen_string_literal: true

module Podcast::PathManagementConcern
  # :reek:UtilityFunction { enabled: false }
  def update_output(suffix, output)
    (output.split('.')[0..-2] + [suffix, :mp3]).join('.')
  end
  # :reek:UtilityFunction { enabled: true }
end
