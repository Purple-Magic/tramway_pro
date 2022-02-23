# frozen_string_literal: true

class PurpleMagic::Api::V1::Leopold::MessagesController < PurpleMagic::Api::ApplicationController
  AVAILABLE_ENGINES = ['Product'].freeze

  include ::BotTelegram::Leopold::Notify

  def create
    if params[:engine].in? AVAILABLE_ENGINES
      engine_object = params[:engine].constantize.find_by uuid: params[:id]
      send_notification_to_chat engine_object.chat_id, params[:message]
    else
      head :bad_request
    end
  end
end
