FactoryBot.define do
    factory :like do
      association :user, factory: :user
      association :likeable, factory: [:article, :comment].sample
    end
end