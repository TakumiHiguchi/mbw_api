class UnapprovedArticle < ApplicationRecord
  belongs_to :article_request

  def create_default_hash
    return({
      :title => self.title,
      :content => self.content,
      :description => self.description,
      :key => self.key
    })
  end
end
