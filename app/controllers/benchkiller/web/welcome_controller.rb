class Benchkiller::Web::WelcomeController < Benchkiller::Web::ApplicationController
  layout 'benchkiller/application'

  def index
    @session_form = ::Tramway::Auth::SessionForm.new ::Tramway::User::User.new
  end
end
