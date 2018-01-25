class Word < ApplicationRecord
  belongs_to :player

  validates :name, presence: true,
                    length: { minimum: 2 }
end
