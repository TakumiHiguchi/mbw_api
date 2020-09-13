namespace :get_lyrics do
  desc "歌詞取得"
    task :get_lyrics, ['first'] => :environment do |task, args|
        require 'nokogiri'
        require 'open-uri'
        require 'csv'

        countop=0 #スクレイピング失敗回数のカウント用変数

        for i in args[:first].to_i..3000000 do
        	#ランダムな文字列生成
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
            id =(0...20).map { o[rand(o.length)] }.join

            #スクレイピング先url
            url = 'https://www.uta-net.com/song/'+i.to_s

            charset = 'utf-8'
            begin
                html = open(url,'User-Agent' => 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)') { |f| f.read }
                rescue OpenURI::HTTPError => e
	                sleep (0.5)
	                countop+=1
	                p "連続失敗回数:"+countop.to_s
	                break if countop>50
	                next
            end

            #成功したらカウントを0に戻す
            countop=0
            doc = Nokogiri::HTML.parse(html, nil, charset)

            #歌詞のスクレイピング
            lyric = doc.xpath('//div[@id="kashi_area"]').inner_html if doc.xpath('//div[@id="kashi_area"]')
            artist = doc.xpath('//span[@itemprop="byArtist name"]').text if doc.xpath('//span[@itemprop="byArtist name"]')
            lyricist = doc.xpath('//h4[@itemprop="lyricist"]').text if doc.xpath('//h4[@itemprop="lyricist"]')
            composer = doc.xpath('//h4[@itemprop="composer"]').text if doc.xpath('//h4[@itemprop="composer"]')
            amazonURL = doc.xpath('//div[@id="view_amazon"]/a/@href')[0].text[/ASIN=(.*)/,1] if doc.xpath('//div[@id="view_amazon"]/a/@href')[0]
            iTunesURL = doc.xpath('//div[@id="view_amazon"]/a[last()]/@href').text[/id(.*)\?i/,1] if doc.xpath('//div[@id="view_amazon"]/a[last()]/@href')
            title = doc.xpath('//h2').text if doc.xpath('//h2')
            jucket = doc.xpath('//div[@id="view_amazon"]/a/img/@src')[0].text if doc.xpath('//div[@id="view_amazon"]/a/img/@src')[0]

            p i
            p 'アーティスト：' + artist + ' 作詞:' + lyricist + ' 作曲:' +composer
            p id

            p '##############################################'

            if Lyric.exists?(:title => title,:artist => artist)then
                p "Lyrics is already exsits."
            else
                book = Lyric.new(
                    :key => id,
                    :title => title,
                    :artist =>artist,
                    :lyricist =>lyricist,
                    :composer => composer,
                    :lyrics => lyric,
                    :amazonUrl =>amazonURL,
                    :iTunesUrl =>iTunesURL 
                )

                #fog carrierwaveでaws s3に画像保存
                if jucket != "/reverse/user/phplib/view/itunes_button.png" && jucket !="/reverse/user/phplib/view/amazon_buy.png" then
                    book.remote_jucket_url = jucket.to_s
                end
                book.save
                fav = Fav.new(:lyric_id => book.id,:fav => 0)
                if fav.save then
                    p "seved"
                end
            end
        end
    end
end
