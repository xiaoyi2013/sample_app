namespace :db do
  desc "fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Example User",
                       email: "example@example.com",
                       password: "example",
                       password_confirmation: "example")
  admin.toggle!(:admin)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@gmail.com"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do |n|
    content = Faker::Lorem.sentence(5)
    users.each do |user|
      user.microposts.create!(content: content)
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each do |followed|
    user.follow!(followed)
  end
  followers.each do |following|
    following.follow!(user)
  end
end
