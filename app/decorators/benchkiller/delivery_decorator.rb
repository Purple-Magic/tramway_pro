# frozen_string_literal: true

class Benchkiller::DeliveryDecorator < ApplicationDecorator
  delegate_attributes :uuid

  def receivers
    content_tag :ul do
      object.receivers.each do |receiver|
        concat(content_tag(:li) do
          receiver.username
        end)
      end
    end
  end

  def markdown_preview
    content_tag :div do
      options = %i[hard_wrap autolink no_intra_emphasis fenced_code_blocks]
      Markdown.new(object.text, *options).to_html.html_safe
    end
  end
end
