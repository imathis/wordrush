class Round < ApplicationRecord
  belongs_to :game
  has_many :turns
  has_many :plays
  has_many :players, through: :turns
  has_many :words, through: :plays

  def new?
    turns.empty?
  end

  def turn_active?
    !new? && !finished?
  end

  def finished?
    words_remaining == 0
  end

  def start_turn
    turns.create(game: game, player: game.next_player)
  end

  def current_turn
    turns.last
  end

  def current_word
    plays.last.word
  end

  def words_remaining
    game.words.size - plays.complete.size
  end

  def number
    game.rounds.find_index(self) + 1
  end
end
