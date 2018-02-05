class CreatePlays < ActiveRecord::Migration[5.1]
  def change
    create_table :plays do |t|
      t.references :round, foreign_key: true
      t.references :turn, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end

    create_table :plays_words, :id => false do |t|
      t.integer :word_id
      t.integer :play_id
    end
  end
end
