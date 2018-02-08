class Play < ApplicationRecord
  belongs_to :round
  belongs_to :turn
  belongs_to :player
  belongs_to :word

  scope :ended, -> { where guessed: true }

  def finish(correct)
    if duration.nil?
      update({
        duration: ( (Time.now.utc - created_at) * 1000 ).round,
        guessed: correct
      })
    end
  end

end
