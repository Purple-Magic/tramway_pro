require 'tramway/collection'

module Collections
  class ItWayActivityLines < ::Tramway::Collection
    class << self
      def list
        [ 'Программирование',
          'Дизайн. Креатив и web-разработка',
          'Дизайн. UX и Проектирование мобильных интерфейсов',
          'Железо',
          'Менеджмент' ]
      end
    end
  end
end
