# frozen_string_literal: true

class Tramway::Conference::Web::WelcomeController < ::Tramway::Conference::ApplicationController
  def index
    super
    # @blocks = ::Tramway::Landing::Block.on_main_page.where(project_id: )
    @blocks = []
    raise
  end
end
