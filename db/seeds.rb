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
    team: game.teams.size % 2,
  }.merge(options)
end

def self.player_word(name)
  {
    name: name
  }
end

library = %w(trees ocean camera syrup lens lake child salsa lamp dessert grill fence candy fire lightning curls olympics patio stapler umbrella)

game = Game.create!( name: short_code)

players = game.players.create!([ 
  new_player("Michael", game, admin: true),
  new_player("Jim", game),
  new_player("Dwight", game),
  new_player("Stanley", game)
])

players.each do |player|
  5.times do
    player.words.create!([ player_word(library.pop)])
  end
end

p "Created #{Game.count} "+ "game".pluralize(Game.count)
