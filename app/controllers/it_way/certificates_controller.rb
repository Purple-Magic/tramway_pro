class ItWay::CertificatesController < ApplicationController
  def show
    @participant = Tramway::Event::Participant.find(params[:id])
    if @participant.approved?
      @certificate = ItWay::Certificate.participants.find_by event_id: @participant.event.id
    else
      head :bad_request
    end
  end
end
