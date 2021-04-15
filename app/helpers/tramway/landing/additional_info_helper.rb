# frozen_string_literal: true

module Tramway::Landing
  module AdditionalInfoHelper
    include ::Tramway::Core::ApplicationHelper
    include ::Tramway::Admin::ApplicationHelper

    def red_magic_timeline
      [
        {
          badge: 'Проработка сценария',
          icon: 'file-alt',
          description: 'Мы совместно разрабатываем план прямого эфира. В зависимости от специфики мероприятия, это либо продуманный до секунды сценарий, либо порядок действий, которые нужно будет сделать',
          subtitle: '1 неделя до прямого эфира',
          type: :primary
        },
        {
          badge: 'Создание уникального контента',
          icon: 'video',
          description: 'Наша команда создаёт уникальный контент для вашей трансляции: дополнительные видео, анимации, переходы и многое другое. Такой подход сделает ваш прямой эфир более брендоориентированным',
          subtitle: '4 дня до прямого эфира',
          type: :primary
        },
        {
          badge: 'Подготовка сцен и площадок для эфира',
          icon: 'air-freshener',
          description: 'Мы стараемся подходить картинку прямых эфиров более художественную, чем обычно это делают другие команды. В этой связи мы готовим специальные конфигурации студии для каждого прямого эфира: настройка света, акустики и так далее',
          subtitle: '3 часа до прямого эфира',
          type: :warning
        },
        {
          badge: 'Подготовка технической базы для обеспечения трансляции',
          icon: 'server',
          description: 'Мы используем сервера для проведения трансляций. Такой подход позволяет нам вести прямые эфиры одновременно в нескольких социальных сетях: Youtube, Instagram, ВКонтакте, twitter и так далее',
          subtitle: '1 час до прямого эфира',
          type: :warning
        },
        {
          badge: 'Проведение непосредственно прямого эфира',
          icon: 'camera',
          description: 'Здесь всё проходит, как по маслу',
          subtitle: 'Прямой эфир',
          type: :success
        },
        {
          badge: 'Анализ контента',
          icon: 'microscope',
          description: 'После прямого эфира совместно с командой клиента мы просматриваем и анализируем статистику просмотров, читаем комментарии и делаем выводы для следующих проектов',
          subtitle: 'Следующий день после прямого эфира',
          type: :info
        }
      ]
    end
  end
end
