class Player < ApplicationRecord
  belongs_to :game
  has_many :words, dependent: :destroy
end
