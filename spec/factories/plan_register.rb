FactoryBot.define do
  factory :plan_register do
    email { "test@test.com" }
    key { BaseWorker.new.get_key }
    maxage { Time.new(2112, 6, 30, 23, 59, 60, 0) } 
    name { Faker::Lorem.sentence }
    session { Digest::SHA256.hexdigest(Digest::SHA256.hexdigest(Time.now.to_i.to_s)) }
  end
end
