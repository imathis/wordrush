class Word < ApplicationRecord
  belongs_to :player
  has_many :plays
  has_many :turns, through: :plays

  validates :name, presence: true,
                    length: { minimum: 2 }

  before_create :word_exists?
  after_create  :update_player_ready

  def word_exists?
    if player.game.words.map(&:name).map(&:downcase).include?(name.downcase)
      raise NameError.new("Word '#{name}' has already been chosen. Think of another word.")
    end
  end

  private

  def update_player_ready
    if player.words_left == 0
      player.update(ready: true)
    end
  end
end
