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

Game.create!(
  name: short_code
  ).players.create!([
    {
      name: "Josh",
      game_id: short_code,
      admin: true,
      score: 5,
      duration: 150,
      team: 0
    },
    {
      name: "Amy",
      game_id: short_code,
      admin: false,
      score: 7,
      duration: 160,
      team: 1
    },
    {
      name: "David",
      game_id: short_code,
      admin: false,
      score: 10,
      duration: 120,
      team: 0
    },
    {
      name: "Louis",
      game_id: short_code,
      admin: false,
      score: 6,
      duration: 120,
      team: 1
    }
  ])
 
p "Created #{Game.count} games"