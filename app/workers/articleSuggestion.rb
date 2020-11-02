class ArticleSuggestion
  def get_article_suggestions(count: 10, query: '')
    return get_including_characters_article({ :count => count, :query => query }).map{|data| data.article_default_hash }
  end

  def get_including_characters_article(props)
    return Article.limit(props[:count]) unless props[:query]
    result = Article.where(
      ['UPPER(title) LIKE ?', "%#{props[:query].upcase}%"]
    ).or(Article.where(
      ['UPPER(content) LIKE ?', "%#{props[:query].upcase}%"]
    )).order("RANDOM()").limit(props[:count])
    return result + Article.order("RANDOM()").limit(props[:count] - result.count)
  end

end
