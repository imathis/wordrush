class RemoveGameExpiration < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :expiration
  end
end
