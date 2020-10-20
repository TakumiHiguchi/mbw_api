class BaseWorker
  def get_key
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    return (0...20).map { o[rand(o.length)] }.join
  end

  def view_remaining_percentage(props)
    print "\r#{ props[:label] }を作成中...（#{ props[:count] }/#{ props[:max] }） Progress:#{ props[:count] * 100 / props[:max] }%"
    print "\n" if props[:max] == props[:count] 
  end
end
