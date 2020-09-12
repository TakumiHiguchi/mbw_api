class Article < ApplicationRecord
    mount_uploader :thumbnail, ImageUploader
    has_many :article_tag_relations
    has_many :tags, through: :article_tag_relations

    def image_from_base64(b64)
        bin = Base64.decode64(b64)
        file = Tempfile.new('img')
        file.binmode
        file << bin
        file.rewind
        p file
        self.update(thumbnail:file)
    end
end
