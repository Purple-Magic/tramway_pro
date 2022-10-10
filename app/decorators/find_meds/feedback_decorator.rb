# frozen_string_literal: true

class FindMeds::FeedbackDecorator < ApplicationDecorator
  delegate_attributes :text

  alias title text
end
