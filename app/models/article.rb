class Article < ApplicationRecord
    mount_uploader :thumbnail, ImageUploader
    has_many :article_tag_relations
    has_many :tags, through: :article_tag_relations

    def image_from_base64(b64)
        uri = URI.parse(b64)
        if uri.scheme == "data" then
            data = decode(uri)
            extension = extension(uri)
            file = decode64_tempfile(data,extension)
            self.update(thumbnail:file)
        end
    end
    def decode(uri)
        opaque = uri.opaque
        data = opaque[opaque.index(",") + 1, opaque.size]
        Base64.decode64(data)
    end
    
    def extension(uri)
        opaque = uri.opaque
        mime_type = opaque[0, opaque.index(";")]
        p opaque
        case mime_type
        when "image/png" then
          ".png"
        when "image/jpeg" then
          ".jpg"
        else
          raise "Unsupport Content-Type"
        end
    end
    def decode64_tempfile(f,extension)
        file = Tempfile.new(['test', extension])
        file.binmode
        file << f
        file.rewind
        return file
    end
end
