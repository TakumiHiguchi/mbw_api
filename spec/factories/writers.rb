FactoryBot.define do
  factory :writer do
    email { "test@test.com" }
    password { Digest::SHA256.hexdigest(Digest::SHA256.hexdigest("test" + 'music.branchwith')) }
  end
end
