class PurpleMagic::Api::V1::Estimation::ProjectsController < PurpleMagic::Api::ApplicationController
  def update
    project = ::Estimation::Project.find params[:id]
    project.send params[:process]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: ::Estimation::Project)
  end
end
