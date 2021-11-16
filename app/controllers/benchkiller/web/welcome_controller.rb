class Benchkiller::Web::WelcomeController < Benchkiller::Web::ApplicationController
  def index
    @session_form = ::Benchkiller::Auth::UserForm.new ::BotTelegram::User.new
  end
end
