class Benchkiller::Web::ApplicationController < Benchkiller::ApplicationController
  layout 'benchkiller/application'
  before_action :authenticate_user!

  def authenticate_user!
    if !current_user && !request.path.in?(['/'])
      redirect_to '/'
    end
  end

  def current_user
    user = ::Benchkiller::User.find_by id: session['benchkiller/user_id']
    return false unless user

    ::Benchkiller::UserDecorator.decorate user
  end
end
