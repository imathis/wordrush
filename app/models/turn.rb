class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :player
  belongs_to :game
  has_many :plays, dependent: :destroy
  has_many :words, through: :plays

  # length in miliseconds
  def time_limit
    60
  end

  def new?
    plays.empty?
  end

  def time_elapsed
    Time.now - plays.first.created_at
  end

  def time_remaining
    t = (time_limit - time_elapsed).ceil
    t <= 0 ? 0 : t
  end

  def finished?
    next_word.nil? || time_remaining <= 0
  end

  def next_word
    (game.words - played_words).shuffle.first
  end

  def played_words
    complete = game.plays.complete.order(:duration)
    complete.empty? ? [] : complete.map(&:word)
  end

  def finish_word
    if p = plays.last
      p.finish(0 < time_remaining)
    end
  end

  def current_word
    plays.last.word
  end

  def words_remaining
    round.words_remaining
  end

  def score
    plays.complete.map(&:score)
  end

  def play_word
    finish_word

    if w = next_word
      plays.create(round: round, player: player, word: w, index: plays.size)
    end
  end
end
