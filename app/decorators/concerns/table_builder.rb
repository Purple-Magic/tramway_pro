# frozen_string_literal: true

module Concerns::TableBuilder
  def th(&block)
    content_tag(:th) do
      yield if block
    end
  end

  def td(&block)
    content_tag(:td) do
      yield if block
    end
  end
end
