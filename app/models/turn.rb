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
    (game.words - played_words).shuffle.first
  end

  def played_words
    complete = plays.where.not(duration: nil).order(:duration)
    complete.empty? ? [] : complete.map(&:word)
  end

  def finish_word
    if p = plays.last
      p.finish
    end
  end

  def play_word
    finish_word

    if w = next_word
      plays.create(game: game, round: round, player: player, word: w)
    end
  end
end
