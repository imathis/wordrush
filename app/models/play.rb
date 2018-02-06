class Play < ApplicationRecord
  belongs_to :round
  belongs_to :turn
  belongs_to :player
  belongs_to :word

  scope :complete, -> { where.not duration: nil }

  def finish
    if duration.nil?
      update duration: ( (Time.now - created_at) * 1000 ).round
    end
  end

end
