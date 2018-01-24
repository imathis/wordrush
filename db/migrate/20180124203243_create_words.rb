class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.string :name
      t.integer :duration
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
