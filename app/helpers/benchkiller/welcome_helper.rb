module Benchkiller::WelcomeHelper
  def welcome_title
    content_for :title do
      "#{t('.title')} | Benchkiller"
    end
  end
end
