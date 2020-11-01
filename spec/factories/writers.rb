FactoryBot.define do
  factory :writer do
    email { "test@test.com" }
    password { Digest::SHA256.hexdigest(Digest::SHA256.hexdigest("test" + 'music.branchwith')) }
    maxage { Time.new(2112, 6, 30, 23, 59, 60, 0) } 

    after(:create) do |writer|
      create(:payment, writer: writer)
    end

    trait :with_article_request do
      after(:create) do |writer|
        create(:writer_article_request_relation, writer: writer, article_request: create(:article_request))
      end
    end
  end
end
