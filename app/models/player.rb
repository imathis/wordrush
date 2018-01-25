class Player < ApplicationRecord
  belongs_to :game
  has_many :words, dependent: :destroy

  validates :name, presence: true,
                    length: { minimum: 2 }

  def word_limit
    5
  end

  def words_left
    word_limit - words.size
  end
end
