class Round < ApplicationRecord
  belongs_to :game
  has_many :turns
  has_many :plays
  has_many :players, through: :turns
  has_many :words, through: :plays

  def words_left?
    game.words.size != words.size
  end

  def start_turn
    turns.create(game: game, player: game.next_player)
  end

end
