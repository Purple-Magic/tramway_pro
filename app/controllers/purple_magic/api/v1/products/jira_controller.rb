class PurpleMagic::Api::V1::Products::JiraController < PurpleMagic::Api::ApplicationController
  def create
    begin
      raise 'Jira'
    rescue StandardError => error
      Airbrake.notify error, params: params
    end
  end
end
