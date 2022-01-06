# frozen_string_literal: true

class TramwayDevDecorator < ApplicationDecorator
  delegate_attributes :title
end
