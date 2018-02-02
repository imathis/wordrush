class CreateTurns < ActiveRecord::Migration[5.1]
  def change
    create_table :turns do |t|
      t.references :round, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
