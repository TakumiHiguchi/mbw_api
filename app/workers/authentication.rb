class Authentication
  def get_SHA256_pass(phrase: nil)
    return Digest::SHA256.hexdigest(Digest::SHA256.hexdigest(phrase.to_s + 'music.branchwith'))
  end

  def check_passphrase(phrase: nil)
    return phrase.match(/\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,12}\z/)
  end

  def isWriter?(props)
    user = Writer.find_by(email:props[:email],session:props[:session])
    return user && user.maxage > Time.now.to_i
  end

  def isAdmin?(props)
    #sessionの確認
    user = Writer.find_by(email:props[:email],session:props[:session])
    now = Time.now.to_i
    if props[:email] == "uiljpfs4fg5hsxzrnhknpdqfx@gmail.com" && !user.nil? && user.maxage > now
      return true
    else
      return false
    end
  end

  def signin(props)
    pass = get_SHA256_pass(phrase: props[:phrase])
    if props[:type] == "writer"
      user = Writer.find_by(email:props[:email],password:pass)
    end
    if user
      session = Digest::SHA256.hexdigest(rand(1000000000).to_s + user.email + Time.now.to_i.to_s)
      maxAge = Time.now.to_i + 3600
      user.update(session:session,maxage:maxAge)
      return {isSignin:true,session:session,maxAge:maxAge}
    else
      return {isSignin:false}
    end
  end

  def getAuthInf(props)
    require "digest"
    #keyを生成
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    key = (0...20).map { o[rand(o.length)] }.join

    #maxAgeを設定
    maxAge = Time.now.to_i
    maxAge += props[:age] if props[:age]

    #sessionを生成
    session = Digest::SHA256.hexdigest(Digest::SHA256.hexdigest(rand(1000000000).to_s + key + Time.now.to_i.to_s))
    return({
      key:key,
      maxAge:maxAge,
      session:session
    })
  end
end
