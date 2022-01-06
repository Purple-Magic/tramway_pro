# frozen_string_literal: true

module Concerns::TableBuilder
  def th
    content_tag(:th, &block)
  end

  def td
    content_tag(:td, &block)
  end
end
