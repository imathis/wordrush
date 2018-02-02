class Play < ApplicationRecord
  belongs_to :turn
  has_and_belongs_to_many :words

end
