class Player < ApplicationRecord
  belongs_to :game

  before_create :choose_team
  before_create :set_admin
  before_create :name_exists?

  has_many :turns
  has_many :plays
  has_many :rounds, through: :turns
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

  def name_exists?
    if game.players.map(&:name).map(&:downcase).include?(name.downcase)
      raise NameError.new("Someone named '#{name}' has already joined. Please enter a different name.")
    end
  end

  def choose_team
    self.team = game.players.size % game.team_count
  end

  def set_admin
    self.admin = game.players.size == 0
  end

end
