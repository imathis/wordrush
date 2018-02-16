class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :name
      t.boolean :admin
      t.integer :team
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
