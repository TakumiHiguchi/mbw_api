
base_worker = BaseWorker.new

create_count = {
  :article => 100,
  :tag => 100,
  :lyrics => 100,
}

def development_seed(create_count)
  base_worker = BaseWorker.new
  # Article
  create_count[:article].times do |count|
    Article.create(
      :title => Faker::Lorem.sentence,
      :content => Faker::Lorem.paragraph(sentence_count: 200),
      :key => base_worker.get_key,
      :description => Faker::Lorem.paragraph(sentence_count: 20),
      :thumbnail => nil,
      :release_time => Time.new.to_i,
      :isindex => true
    )
    base_worker.view_remaining_percentage({ label: "Yuz: Article", count: count+1, max: create_count[:article] })
  end

  # Tag
  create_count[:tag].times do |count|
    Tag.create(
      :name => Faker::Lorem.sentence,
      :key => base_worker.get_key,
      :description => Faker::Lorem.paragraph(sentence_count: 20),
      :thumbnail => nil
    )
    base_worker.view_remaining_percentage({ label: "Yuz: Tag", count: count+1, max: create_count[:tag] })
  end

  # 記事とタグの関連付け
  Article.all.each_with_index do |article, count|
    article.article_tag_relations.build(
      tag_id: rand(9) + 1
    )
    article.save
    base_worker.view_remaining_percentage({ label: "Yuz: ArticleTagRelation", count: count+1, max: Article.count })
  end

  # lyrics
  create_count[:lyrics].times do |count|
    lyric = Lyric.create(
      :title => Faker::Lorem.sentence,
      :key => base_worker.get_key,
      :artist => Faker::Artist.name,
      :lyricist => Faker::Artist.name,
      :composer => Faker::Artist.name,
      :jucket => nil,
      :lyrics => Faker::Lorem.paragraph(sentence_count: 200),
      :amazonUrl => nil,
      :iTunesUrl => nil
    )
    lyric.build_fav(
      :fav => rand(10000)
    )
    lyric.save
    base_worker.view_remaining_percentage({ label: "Yuz: Lyrics", count: count+1, max: create_count[:tag] })
  end

  # mbwWebGUIadmin初期データの作成
  auth = Authentication.new()
  inf = auth.getAuthInf(age:3600)
  PlanRegister.create(
    email:"test@test.com",
    key:inf[:key],
    maxage:inf[:maxAge],
    session:inf[:session],
    name:"ひいらぎ"
  )

  admin_user = Writer.new(
    :email => "admin@test.com",
    :password => auth.get_SHA256_pass(phrase: "Administrator1"),
    :admin => true,
    :editor => true
  )

  admin_user.build_payment(
    :unsettled => 200000,
    :confirm => 999,
    :paid => 1000,
  )

  admin_user.save
end

print "\n- music.branchwithのテストデータを作成します.\n\n"

if Rails.env.development?
  print "Yuz: migrate:resetを行います.\n"
  print "Yuz: この処理はdevelopment環境のみ行われます.\n\n"
  print "Yuz: 削除中.\n"
  if system('rails db:migrate:reset')
    print "Yuz: 削除しました.\n\n"
    print "Yuz: 続いてテストデータを作成します.\n"
    development_seed(create_count)
  end
end 

print "\nYuz: テストデータの作成が完了しました.\n\n"
print "\nYuz: music.branchwithWEBGUI用のパスワード設定URLを表示します.\nYuz: music.branchwithWEBGUIを起動したのち、アクセスしてください。\n\n"
if Rails.env.development?
  puts PlanRegister.getUrl()
else
  puts PlanRegister.getUrl(url: "https://music-branchwith-web-gui.web.app/signup")
end
print "\n"

