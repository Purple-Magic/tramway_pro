module Benchkiller::ApplicationHelper
  def signed_in?
    session['benchkiller/user_id'].present?
  end
end
