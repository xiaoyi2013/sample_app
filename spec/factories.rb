FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@example.com" }
    password "abc123abc"
    password_confirmation "abc123abc"
    factory :admin do
      admin true
    end
  end
  factory :micropost do
    content "micropost"
    user
  end
end
