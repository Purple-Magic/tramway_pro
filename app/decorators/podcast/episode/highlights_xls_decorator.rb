# frozen_string_literal: true

class Podcast::Episode::HighlightsXlsDecorator < Tramway::Export::Xls::ApplicationDecorator
  delegate_attributes :time

  class << self
    def columns
      [ :time ]
    end

    def filename
      'episode.xls'
    end

    def sheet_name
      'Хайлайты'
    end
  end
end
