FactoryBot.define do
  factory :writer do
    email { "test@test.com" }
    password { Digest::SHA256.hexdigest(Digest::SHA256.hexdigest("test" + 'music.branchwith')) }
    maxage { Time.new(2112, 6, 30, 23, 59, 60, 0) } 
  end
end
