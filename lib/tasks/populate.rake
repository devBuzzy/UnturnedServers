namespace :db do
  task :populate => :environment do
    require 'faker'
    desc "Create 100 users with random names and descriptions"
    5.times do
      user = User.new
      user.username = Faker::Internet.user_name
      user.email = Faker::Internet.email
      user.password = Faker::Internet.password
      user.save
      puts "Saved new user."
    end
    users = User.all.shuffle.to_a
    tags = Tag.all
    1000.times do 
      server = Server.new
      server.user = users.sample
      server.title = Faker::Company.name
      server.info = "This is a really cool server that I made for anyone to come join. I think that you should come join this so that you can have lots of fun with me and my friends who enjoy playing on this server with me. We have lots of cool plugins like free experience, lotsa swag, and even super extra cool vehicles that you can only find on my server! If you want to come join me, just click the connect button at the top! Can't wait to see you on our amazing server. Bye for now, see you soon, can't wait!"
      server.ip = Faker::Internet.ip_v4_address
      server.port = Faker::Number.number(5)
      server.country = ["US", "CA", "MX", "EG"].sample
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

    Tag.all.to_a.each do |tag|
      tag.save
    end
    puts 'All done'
  end
end