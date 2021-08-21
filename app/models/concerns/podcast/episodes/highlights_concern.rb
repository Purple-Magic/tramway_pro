# frozen_string_literal: true

module Podcast::Episodes::HighlightsConcern
  def cut_highlights
    filename = convert_file
    wait_for_file_rendered filename, :convert
    highlights.each_with_index do |highlight, index|
      highlight.cut_from_whole_file filename, index
    end
  end
end
