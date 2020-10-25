FactoryBot.define do
  factory :lyric do
    title { Faker::Lorem.sentence }
    artist { Faker::Artist.name }
    lyricist { Faker::Artist.name }
    composer { Faker::Artist.name }
    jucket { nil }
    key { BaseWorker.new.get_key }
    lyrics { Faker::Lorem.paragraph(sentence_count: 200) }
    amazonUrl { nil }
    iTunesUrl { nil }

    trait :with_favs do
      after(:create) do |lyrics|
        lyrics.favs << create(:fav)
      end
    end
  end
end
