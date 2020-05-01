# frozen_string_literal: true

class Engineervol::Web::WelcomeController < ApplicationController
  layout 'engineervol/application'

  def index
    @application = Constraints::DomainConstraint.new(request.domain).application_object
    @book = Listai::Book.first
  end
end
