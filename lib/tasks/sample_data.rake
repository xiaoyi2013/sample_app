namespace :db do
  desc "fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                         email: "example@gmail.com",
                         password: "foobar123",
                         password_confirmation: "foobar123")
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
end