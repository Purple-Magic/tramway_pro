# frozen_string_literal: true

module Concerns::AudioControls
  def audio(**_options, &block)
    content_tag :audio, controls: true, style: 'width: 100%', &block
  end
end
