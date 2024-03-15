FactoryBot.define do
    factory :article do
      title { Faker::Lorem.word }
      body { Faker::Lorem.sentence}
      status { "public" }
      association :user, factory: :user
    end
end