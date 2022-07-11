class YoutubeCallbacksController < ApplicationController
  def create
    yt = Youtube::Account.new authorization_code: params[:code]
    yt.save!
    redirect_to root_path
  end
end
