FactoryBot.define do
  factory :article_request do
    key { BaseWorker.new.get_key }
    content { Faker::Lorem.paragraph(sentence_count: 200) }
    title { Faker::Lorem.sentence }
    status { 1 }
  end
end
