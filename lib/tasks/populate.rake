namespace :db do
  task :populate => :environment do
    require 'faker'
    desc "Create 100 users with random names and descriptions"
    1.times do
      user = User.new
      user.username = Faker::Internet.user_name
      user.email = Faker::Internet.email
      user.password = Faker::Internet.password
      user.save
      puts "Saved new user."
    end
    users = User.all.shuffle.to_a
    tags = ["PvP", "Sync", "No Sync", "Hardcore", "Normal", "Custom Map", "P.E.I."]
    100.times do 
      server = Server.new
      server.user = users.sample
      server.title = Faker::Company.name
      server.info = Faker::Lorem.paragraph(2)
      server.ip = Faker::Internet.ip_v4_address
      server.port = Faker::Number.number(5)
      server.country = ["US", "CA", "MX", "UK"].sample
      server.tags << tags.sample
      server.tags << tags.sample
      server.tags << tags.sample
      server.version = ["2.2.4", "2.2.5"].sample
      server.slots = rand(64)
      server.website = Faker::Internet.url
      server.banner = File.open("C:/Users/jake/Pictures/banner.png")
      votes = rand(20)
      votes.times do
        vote = server.votes.new
        vote.ip = Faker::Internet.ip_v4_address
        vote.save
      end
      favorites = rand(5)
      favorites.times do 
        favorite = server.favorites.new
        favorite.user = users.sample
        favorite.save
      end
      vote_count = server.votes.size
      server.save
      puts "Saved new server."
    end
    puts 'All done'
  end
end