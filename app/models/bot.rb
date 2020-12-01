class Bot < ApplicationRecord
  enumerize :team, in: [ :rsm, :night ]
end
