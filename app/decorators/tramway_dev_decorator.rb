# frozen_string_literal: true

class TramwayDevDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title
end
