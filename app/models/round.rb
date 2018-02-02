class Round < ApplicationRecord
  belongs_to :game
  has_many :turns
  has_many :players, through: :turns

  # length in miliseconds
  def length
    62000
  end

  def words_left?
    game.words.size != words.size
  end

end
