namespace :db do
  task :populate => :environment do
    require 'faker'
    desc "Create 100 users with random names and descriptions"
    75.times do
      user = User.new
      user.username = Faker::Internet.user_name
      user.email = Faker::Internet.email
      user.password = Faker::Internet.password
      user.save
    end
    users = User.all.shuffle.to_a
    100.times do 
      server = Server.new
      server.user = users.sample
      server.title = Faker::Company.name
      server.info = Faker::Lorem.paragraph(2)
      server.ip = Faker::Internet.ip_v4_address
      server.port = Faker::Number.number(5)
      server.pvp = [true, false].sample
      server.map = "P.E.I"
      server.location = ["north-america", "africa", "australia", "europe"].sample
      server.difficulty = ["normal", "hardcore", "gold", "bambi"].sample
      server.version = ["2.2.4", "2.2.5"].sample
      server.sync = [true, false].sample
      server.slots = rand(64)
      server.website = Faker::Internet.url
      server.banner = File.open("C:/Users/jake/Pictures/banner.png")
      votes = rand(100)
      votes.times do
        vote = server.votes.new
        vote.user = users.sample
        vote.save
      end
      favorites = rand(20)
      favorites.times do 
        favorite = server.favorites.new
        favorite.user = users.sample
        favorite.save
      end
      vote_count = server.votes.size
      server.save
    end
    puts 'All done'
  end
end