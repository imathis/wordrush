class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  def to_param 
    name
  end

end
