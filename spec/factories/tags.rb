FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.sentence }
    key { BaseWorker.new.get_key }
    description { Faker::Lorem.paragraph(sentence_count: 20) }
    thumbnail { nil }
  end
end
