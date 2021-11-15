# frozen_string_literal: true

class Benchkiller::Web::SessionsController < ::Tramway::Auth::Web::ApplicationController
  before_action :redirect_if_signed_in, except: :destroy

  def create
    @session_form = ::Benchkiller::Auth::UserForm.new ::Benchkiller::User.active.joins(:telegram_user).where('bot_telegram_users.username = ?', params[:bot_telegram_user][:username]).first
    if @session_form.model.present?
      if @session_form.need_to_generate_password?
        redirect_to ['/', '?', { flash: :you_need_to_generate_password }.to_query].join
      else
        if @session_form.validate params[:bot_telegram_user]
          sign_in @session_form.model
          redirect_to '/benchkiller/web/offers'
        else
          redirect_to '/'
        end
      end
    else
      redirect_to '/'
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
