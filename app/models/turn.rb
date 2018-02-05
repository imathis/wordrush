class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :player
  belongs_to :game
  has_many :plays, dependent: :destroy
  has_many :words, through: :plays

  # length in miliseconds
  def length
    62000
  end

  def next_word
    (game.words - words).shuffle.first
  end

  def play_word
    play = plays.create(round: round, player: player)
    play.words << next_word
    play
  end
  
end
