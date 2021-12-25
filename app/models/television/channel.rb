class Television::Channel < ApplicationRecord
  enumerize :channel_type, in: [ 'repeated', 'custom' ]
end
