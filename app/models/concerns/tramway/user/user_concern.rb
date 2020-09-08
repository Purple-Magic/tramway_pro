module Tramway::User::UserConcern
  extend ActiveSupport::Concern
  
  included do
    enumerize :role, in: [ :admin, :partner ], default: :admin
  end
end
