module Concerns::AudioControls
  def audio(**options, &block)
    content_tag :audio, controls: true, style: 'width: 100%' do
      yield
    end
  end
end
