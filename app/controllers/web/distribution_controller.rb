class Web::DistributionController < ApplicationController
  def index
    if request.host.include?('sportschool-ulsk.ru')
      redirect_to '/sport_school'
    end
  end
end
