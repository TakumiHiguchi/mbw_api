FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 20) }
    content { Faker::Lorem.paragraph(sentence_count: 200) }
    thumbnail { nil }
    release_time { Time.new.to_i }
    key { BaseWorker.new.get_key }
    isindex { true }

    trait :with_tags do
      after(:create) do |article|
        article.tags << create_list(:tag, 3)
      end
    end
  end
end
