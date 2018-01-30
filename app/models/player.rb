class Player < ApplicationRecord
  belongs_to :game

  before_create :choose_team
  before_create :set_admin

  has_many :words, dependent: :destroy

  validates :name, presence: true,
                    length: { minimum: 2 }
  def player_id
    id
  end

  def word_limit
    5
  end

  def words_left
    word_limit - words.size
  end

  def choose_team
    self.team = game.players.size % 2
  end

  def set_admin
    self.admin = game.players.size == 0
  end
end
