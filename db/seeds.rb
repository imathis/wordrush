# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Game.destroy_all
 
def self.short_code
  source = [*?A..?Z] - ['O']
  short = ''
  5.times { short << source.sample.to_s }
  short
end

def self.new_player(name, game, options={})
  {
    name: name,
    team: game.teams.size % 2
  }.merge(options)
end

game = Game.create!( name: short_code)
game.players.create!([ 
  new_player("Josh", game, admin: true),
  new_player("Amy", game),
  new_player("David", game),
  new_player("Louis", game)
])
 
p "Created #{Game.count} "+ "game".pluralize(Game.count)
