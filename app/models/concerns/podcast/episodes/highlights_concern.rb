# frozen_string_literal: true

module Podcast::Episodes::HighlightsConcern
  def cut_highlights
    highlights.each_with_index do |highlight, index|
      highlight.cut_from_whole_file index
    end
  end
end
