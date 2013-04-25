namespace :db do
  desc "fill database with sample data"
  task populate: :environment do
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
    users = User.all(limit: 6)
    50.times do |n|
      content = Faker::Lorem.sentence(5)
      users.each do |user|
        user.microposts.create!(content: content)
      end
    end
  end
end
