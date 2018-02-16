class Play < ApplicationRecord
  belongs_to :round
  belongs_to :turn
  belongs_to :player
  belongs_to :word

  scope :complete, -> { where guessed: true }

  def finish(correct)
    if duration.nil?
      update({
        duration: ( (Time.now.utc - created_at) * 1000 ).round,
        guessed: correct
      })
    end
  end

  def score
    s = {
      base: guessed ? 10 : 0
    }

    num = index + 1

    if guessed
      if duration < 5
        s[:speed_bonus] = 5 
      end

      if 9 < num
        s[:word_bonus] = num
      elsif 5 < num
        s[:word_bonus] = num - 5
      end
    end


    s[:total] = s.values.sum

    s
  end

end
