class Article < ApplicationRecord
    mount_uploader :thumbnail, ImageUploader
    has_many :article_tag_relations
    has_many :tags, through: :article_tag_relations

    def image_from_base64(b64)
        uri = URI.parse(b64)
        if uri.scheme == "data" then
            opaque = uri.opaque
            data = opaque[opaque.index(",") + 1, opaque.size]
            bin = Base64.decode64(data)
            file = Tempfile.new('img')
            file.binmode
            file << bin
            file.rewind
          
            self.update(thumbnail:file)
        end
    end
end
