# frozen_string_literal: true

class Benchkiller::Web::ApplicationController < Benchkiller::ApplicationController
  layout 'benchkiller/application'
  before_action :authenticate_user!

  def authenticate_user!
    redirect_to '/' if !current_user && !request.path.in?(['/'])
  end

  def current_user
    user = ::Benchkiller::User.find_by id: session['benchkiller/user_id']
    return false unless user

    ::Benchkiller::UserDecorator.decorate user
  end
end
