class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :player
  belongs_to :game
  has_many :plays, dependent: :destroy
  has_many :words, through: :plays

  # length in seconds (add a couple of seconds to account for load time)
  def time_limit
    62
  end

  def new?
    plays.empty?
  end

  def time_elapsed
    Time.now - plays.first.created_at
  end

  def ms_remaining
    (1000 * time_remaining).ceil
  end

  def seconds_remaining
    t = (time_remaining).ceil
    t <= 0 ? 0 : t
  end

  def time_remaining
    time_limit - time_elapsed
  end

  def finished?
    next_word.nil? || !plays.empty? && time_remaining <= 0
  end

  def next_word
    (game.words - played_words).shuffle.first
  end

  def finish
    plays.last.finish(false)
  end

  def played_words
    complete = round.plays.complete.order(:duration)
    complete.empty? ? [] : complete.map(&:word)
  end

  def finish_word(complete=nil)
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
