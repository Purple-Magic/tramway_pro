# frozen_string_literal: true

class Gorodsad73::Web::WelcomeController < ApplicationController
  layout 'tramway/landing/application'

  def index
    @application = Constraints::DomainConstraint.new(request.domain).application_object
    page_path = proc do |slug|
      Tramway::Page::Engine.routes.url_helpers.page_path(slug)
    end
    @links = {
      right: [
        Tramway::Landing::Navbar::LinkDecorator.decorate(
          { title: 'Профиль', link: page_path.call(:profile) }
        ),
        Tramway::Landing::Navbar::LinkDecorator.decorate(
          { title: 'Посчитаем бюджет', link: page_path.call(:price) }
        ),
        Tramway::Landing::Navbar::LinkDecorator.decorate(
          { title: 'Контакты', link: page_path.call(:contacts) }
        )
      ]
    }
  end
end
