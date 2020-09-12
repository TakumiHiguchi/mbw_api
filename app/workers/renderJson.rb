class RenderJson
  def createError(props)
    case props[:code]
      when 'AE_0001'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'アクセス権限がありません'
        })
      when 'AE_0002'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'アクセス権限がありません。サインインしてください'
        })
      when 'AE_0003'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'トークンの有効期限が切れています'
        })
      when 'AE_0004'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'登録できませんでした。再度お試しください'
        })
      when 'AE_0005'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'パスワードは半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります'
        })
      when 'AE_0006'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'メールアドレスかパスワードが正しくありません'
        })
      when 'AE_0007'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'すでに他の人に執筆されています'
        })
      when 'AE_0014'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'ユーザーが存在しません。契約主に問い合わせてください'
        })
    end
    return json
  end
  
end
