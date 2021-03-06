class BaseWorker
  def get_key
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    return (0...20).map { o[rand(o.length)] }.join
  end

  def view_remaining_percentage(props)
    print "\r#{ props[:label] }を作成中...（#{ props[:count] }/#{ props[:max] }） Progress:#{ props[:count] * 100 / props[:max] }%"
    print "\n" if props[:max] == props[:count] 
  end

  def hit_mbw(props)
    uri = URI.parse("https://musicbranchwith.herokuapp.com/" + props[:url])
    uri.query = URI.encode_www_form(props[:params]) if props[:params]
    https = https_setting(uri)
    https.start do
      query = '?' + uri.query if uri.query
      return https.get(uri.path + query)
    end
  end

  def https_setting(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.open_timeout = 10
    https.read_timeout = 10
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5
    return https
  end

  def google_ad
    '<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><p><ins class="adsbygoogle"style="display:block; text-align:center;"data-ad-layout="in-article"data-ad-format="fluid"data-ad-client="ca-pub-3071406439328000"data-ad-slot="7175887212"></ins></p><script>(adsbygoogle = window.adsbygoogle || []).push({});</script>'
  end
end
