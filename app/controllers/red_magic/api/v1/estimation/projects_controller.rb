# frozen_string_literal: true

class RedMagic::Api::V1::Estimation::ProjectsController < RedMagic::Api::ApplicationController
  def update
    project = ::Estimation::Project.find params[:id]
    project.send params[:process]

    redirect_to ::Tramway::Engine.routes.url_helpers.record_path(params[:id], model: ::Estimation::Project)
  end
end
