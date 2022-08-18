# frozen_string_literal: true

class YoutubeCallbacksController < ApplicationController
  def create
    yt = Youtube::Account.new authorization_code: params[:code]
    yt.save!

    Youtube::TokensService.new(yt).call

    redirect_to root_path
  end
end
