class RenderJson
  def createSuccess(props)
    hash = {
      :status => 200,
      :api_version => props[:api_version]
    }
    props[:result].each{ |ins| hash.merge!(ins) }
    return JSON.pretty_generate(hash)
  end

  def createError(props)
    props[:status] ||= 400
    hash = {
      :status => props[:status],
      :api_version => props[:api_version],
      :error_code => props[:code],
    }
    case props[:code]
      when 'AE_0001'
        hash[:mes] = 'アクセス権限がありません'
      when 'AE_0002'
        hash[:mes] = 'アクセス権限がありません。サインインしてください'
      when 'AE_0003'
        hash[:mes] = 'トークンの有効期限が切れています'
      when 'AE_0004'
        hash[:mes] = '登録できませんでした。再度お試しください'
      when 'AE_0005'
        hash[:mes] = 'パスワードは半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります'
      when 'AE_0006'
        hash[:mes] = 'メールアドレスかパスワードが正しくありません'
      when 'AE_0007'
        hash[:mes] = 'すでに他の人に執筆されています'
      when 'AE_0014'
        hash[:mes] = 'ユーザーが存在しません。契約主に問い合わせてください'
      when 'AE_0101'
        hash[:mes] = 'タグが存在しません。'
    end
    return JSON.pretty_generate(hash)
  end
  
end
