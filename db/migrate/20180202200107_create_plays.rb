class CreatePlays < ActiveRecord::Migration[5.1]
  def change
    create_table :plays do |t|
      t.references :round, foreign_key: true
      t.references :turn, foreign_key: true
      t.references :player, foreign_key: true
      t.references :word, foreign_key: true
      t.integer :duration

      t.timestamps
    end
  end
end
