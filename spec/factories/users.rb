FactoryBot.define do
    factory :user do
        name { Faker::Name.first_name }
        username { Faker::Internet.username }
        email { Faker::Internet.email }
        password { 'Vipul@403' }
        password_digest { BCrypt::Password.create(password) }
        profile_pic {nil}
        cover_pic {nil}
        credits {10}
        premium {false}
        refresh_token { SecureRandom.hex(20) }
    end
end  