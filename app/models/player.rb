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

  def words_left
    game.player_word_limit - words.size
  end

  def team_number
    team + 1
  end

  def ready?
    words_left == 0
  end

  def name_exists?
    if game.players.map(&:name).map(&:downcase).include?(name.downcase)
      raise NameError.new("Someone named '#{name}' has already joined. Please enter a different name.")
    end
  end

  def team_score
    game.team_scores[team]
  end

  def points(round=nil)
    plays.complete.map { |p| 
      if !round || p.round == round
        p.score[:total] 
      else
        0
      end
    }.sum
  end

  def choose_team
    self.team = game.players.size % game.team_count
  end

  def set_admin
    self.admin = game.players.size == 0
  end

  def word_speed
    words.map(&:duration).sum
  end

end
