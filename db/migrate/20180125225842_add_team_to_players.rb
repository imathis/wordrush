class AddTeamToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :team, :integer
  end
end
