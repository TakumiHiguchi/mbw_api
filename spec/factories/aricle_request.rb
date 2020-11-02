FactoryBot.define do
  factory :article_request do
    key { BaseWorker.new.get_key }
    content { Faker::Lorem.paragraph(sentence_count: 200) }
    title { Faker::Lorem.sentence }
    status { 1 }

    trait :with_unapproved_article do
      after(:create) do |article_request|
        create(:unapproved_article, article_request: article_request)
      end
    end
  end
end
