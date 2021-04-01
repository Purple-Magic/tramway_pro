# frozen_string_literal: true

class Gorodsad73::Web::WelcomeController < ApplicationController
  layout 'tramway/landing/application'

  def index
    @application = Constraints::DomainConstraint.new(request.domain).application_object
    @links = {
      right: [
        Tramway::Landing::Navbar::LinkDecorator.decorate(
          { title: 'Профиль', link: Tramway::Page::Engine.routes.url_helpers.page_path(:profile) }
        ),
        Tramway::Landing::Navbar::LinkDecorator.decorate(
          { title: 'Посчитаем бюджет', link: Tramway::Page::Engine.routes.url_helpers.page_path(:price) }
        ),
        Tramway::Landing::Navbar::LinkDecorator.decorate(
          { title: 'Контакты', link: Tramway::Page::Engine.routes.url_helpers.page_path(:contacts) }
        )
      ]
    }
  end
end
