class PurpleMagic::Api::V1::Products::TimeLogsController < PurpleMagic::Api::ApplicationController
  def create
    begin
      raise 'TimeLogCreate'
    rescue StandardError => error
      Airbrake.notify error, params: params
    end
  end

  def update
    begin
      raise 'TimeLogUpdate'
    rescue StandardError => error
      Airbrake.notify error, params: params
    end
  end

  def delete
    begin
      raise 'TimeLogDelete'
    rescue StandardError => error
      Airbrake.notify error, params: params
    end
  end
end
