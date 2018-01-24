class Game < ApplicationRecord
  has_many :players

  def to_param 
    name
  end
end
