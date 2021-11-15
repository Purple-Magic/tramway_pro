# frozen_string_literal: true

class Benchkiller::Web::SessionsController < ::Tramway::Auth::Web::ApplicationController
  before_action :redirect_if_signed_in, except: :destroy

  def create
    @session_form = ::Tramway::Auth::SessionForm.new params[:model].constantize.active.find_by email: params[:user][:email]
    if @session_form.model.present?
      if @session_form.validate params[:user]
        sign_in @session_form.model
        redirect_to [params[:success_redirect], '?', { flash: :success_user_sign_in }.to_query].join || ::Tramway::Auth.root_path_for(@session_form.model.class)
      else
        redirect_to [params[:error_redirect], '?', { flash: :error_user_sign_in }.to_query].join || ::Tramway::Auth.root_path_for(@session_form.model.class)
      end
    else
      redirect_to [params[:error_redirect], '?', { flash: :error_user_sign_in }.to_query].join || ::Tramway::Auth.root_path_for(params[:model].constantize)
    end
  end

  def destroy
    root_path = ::Tramway::Auth.root_path_for(current_user.class)
    sign_out params[:model]
    redirect_to params[:redirect] || root_path
  end

  private

  def redirect_if_signed_in
    if params[:model].present? && signed_in?(params[:model].constantize) && request.env['PATH_INFO'] != ::Tramway::Auth.root_path_for(current_user.class)
      redirect_to ::Tramway::Auth.root_path_for(current_user.class)
    end
  end
end
