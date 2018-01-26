class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  def to_param 
    name
  end

  def game_name
    name
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
end
