# frozen_string_literal: true

module CapybaraHelpers
  module Node
    module Element
      def parent_node(level: 1)
        node = self
        level.times do
          node = node.first(:xpath, './/..')
        end
        node
      end
    end
  end
end

Capybara::Node::Element.include CapybaraHelpers::Node::Element
