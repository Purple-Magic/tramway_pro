class YoutubeCallbacksController < ApplicationController
  def create
    yt = Youtube::Account.new authorization_code: params[:authorization_code]
    yt.save!
  end
end
