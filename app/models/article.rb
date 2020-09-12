class Article < ApplicationRecord
    mount_uploader :thumbnail, ImageUploader
    has_many :article_tag_relations
    has_many :tags, through: :article_tag_relations

    def image_from_base64(b64)
        if !b64.nil?
            bin = Base64.decode64(b64)
            file = Tempfile.new('img')
            file.binmode
            file << bin
            file.rewind
        
            self.update(thumbnail:file)
        end
    end
end
