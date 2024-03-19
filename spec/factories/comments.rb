FactoryBot.define do
    factory :comment do
      body { Faker::Lorem.sentence }
      status { "public" }
      article
      user
    end
end