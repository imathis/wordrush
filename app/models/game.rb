class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: true,
                    length: { minimum: 5, maximum: 10,  }
  def to_param 
    name
  end

  def game_name
    name
  end

  # Game was created 5 hours ago
  def expired?
    created_at.advance(hours: 5) < DateTime.now
  end

  def minimum_players
    4
  end

  def enough_players?
    players.size >= minimum_players
  end

  def needed_players
    minimum_players - players.size
  end

  def teams
    players.empty? ? [] : players.group_by(&:team)
  end

  def self.expired_games
    all.select(&:expired?)
  end

  # Destroy expired games
  def self.scrub_games
    expired_games.map(&:destroy)
  end

  def self.short_code
    source = [*?A..?Z] - ['O']
    short = ''
    5.times { short << source.sample.to_s }
    short
  end
end
