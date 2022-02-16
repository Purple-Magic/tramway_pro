# frozen_string_literal: true

module Concerns::TableBuilder
  def table(&block)
    content_tag(:table, class: 'table table-bordered table-striped') do
      yield if block
    end
  end

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

  def tr(&block)
    content_tag(:tr) do
      yield if block
    end
  end
end
