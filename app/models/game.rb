class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  has_many :words, through: :players
  has_many :turns, through: :rounds

  validates :name, presence: true,
                   uniqueness: true,
                    length: { minimum: 5, maximum: 20 }

  # How many teams should there be?
  def team_count
    2
  end

  def to_param 
    name
  end

  def game_name
    name
  end

  def teams
    players.empty? ? [] : players.group_by(&:team)
  end

  def play_order
    @player_order ||= players.shuffle
  end

  def ready?
    # Enough players here and all players are ready
    # (they have entered all their words)
    enough_players? && !players.map(&:ready?).include?(false)
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

  def started?
    !rounds.empty?
  end

  def round_players
    turns = rounds.map(&:turns)
    turns.empty? ? turns : turns.flatten.map(&:player)
  end

  def next_team_id
    round_players.size % team_count
  end

  def team_turns(team)
    if round_players.empty?
      0
    else
      round_players.select { |p| p.team == team }
    end
  end

  def next_player
    team_id = next_team_id
    team_players = teams[team_id]

    # How many turns for this team?
    plays = team_turns(team_id).size

    team_players[plays % team_players.size]
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
