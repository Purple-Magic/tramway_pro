require 'tramway/collection'

module Collections
  class ItWayActivityLines < ::Tramway::Collection
    class << self
      def list
        [ 'Программирование', 'Дизайн', 'Железо', 'Менеджмент' ]
      end
    end
  end
end
