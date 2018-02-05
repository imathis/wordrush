class Play < ApplicationRecord
  belongs_to :round
  belongs_to :turn
  belongs_to :player
  has_and_belongs_to_many :words

end
