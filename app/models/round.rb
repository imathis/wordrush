class Round < ApplicationRecord
  belongs_to :game
  has_many :turns
  has_many :plays
  has_many :players, through: :turns
  has_many :words, through: :plays

  def plays_left?
    plays.complete.size < game.words.size
  end

  def start_turn
    turns.create(game: game, player: game.next_player)
  end
end
