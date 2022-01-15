# frozen_string_literal: true

class Benchkiller::Api::UserTokensController < ::Benchkiller::Api::ApplicationController
  skip_before_action :authenticate_benchkiller_user

  def create
    params[:user_based_model] ||= 'Benchkiller::User'
    if entity.present? && entity.authenticate(auth_params[:password])
      token = auth_token
      render json: {
        auth_token: token,
        user: {
          username: @entity.username,
          uuid: @entity.uuid
        }
      }, status: :created
    else
      unauthorized
    end
  end
end
