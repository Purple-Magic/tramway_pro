# frozen_string_literal: true

class Benchkiller::Web::SessionsController < ::Tramway::ApplicationController
  before_action :redirect_if_signed_in, except: :destroy

  def create
    user = ::Benchkiller::User.joins(:telegram_user).where('bot_telegram_users.username = ?',
      params[:bot_telegram_user][:username]).first
    if user.present?
      @session_form = ::Benchkiller::Auth::UserForm.new user
      if @session_form.model.present?
        if @session_form.need_to_generate_password?
          redirect_to ['/', '?', { flash: :you_need_to_generate_password }.to_query].join
        elsif @session_form.validate params[:bot_telegram_user]
          sign_in @session_form.model
          redirect_to ['/benchkiller/web/offers', '?', { flash: :success_sign_in }.to_query].join
        else
          redirect_to ['/', '?', { flash: :wrong_username_or_password }.to_query].join
        end
      else
        redirect_to '/'
      end
    else
      redirect_to ['/', '?', { flash: :wrong_username_or_password }.to_query].join
    end
  end

  def destroy
    root_path = '/'
    sign_out 'Benchkiller::User'
    redirect_to params[:redirect] || root_path
  end

  private

  def redirect_if_signed_in
    if params[:model].present? && signed_in?(params[:model].constantize) && request.env['PATH_INFO'] != Tramway.root_path_for(current_user.class)
      redirect_to Tramway.root_path_for(current_user.class)
    end
  end
end
