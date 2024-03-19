FactoryBot.define do
    factory :blocked_user do
      association :user, factory: :user
      association :blocked_user, factory: :user  
    end
end