FactoryBot.define do
  factory :unapproved_article do
    key { BaseWorker.new.get_key }
    content { Faker::Lorem.paragraph(sentence_count: 200) }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    thumbnail { nil }
  end
end
