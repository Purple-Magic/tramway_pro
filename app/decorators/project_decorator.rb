# frozen_string_literal: true

class ProjectDecorator < ApplicationDecorator
  delegate_attributes :title
end
