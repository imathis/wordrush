class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :player
  has_many :plays
  has_many :words, through: :plays

  def start
    word
  end

  def next_word
    [round.game.words - words].shuffle.first
  end

end
