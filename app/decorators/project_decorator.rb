# frozen_string_literal: true

class ProjectDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title
end
