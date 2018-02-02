class Word < ApplicationRecord
  belongs_to :player
  has_and_belongs_to_many :plays

  validates :name, presence: true,
                    length: { minimum: 2 }

  before_create :word_exists?

  def word_exists?
    if player.game.words.map(&:name).map(&:downcase).include?(name.downcase)
      raise NameError.new("Word '#{name}' has already been chosen. Think of another word.")
    end
  end
end
