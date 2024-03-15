FactoryBot.define do
    factory :account_verification do
      user { association :user }
      email_confirmed { false }
      confirm_token { SecureRandom.hex }
    end
end