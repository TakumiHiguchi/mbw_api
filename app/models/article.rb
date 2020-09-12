class Article < ApplicationRecord
    mount_uploader :thumbnail, ImageUploader
    has_many :article_tag_relations
    has_many :tags, through: :article_tag_relations

    def image_from_base64(b64)
        image = b64
        return unless image.present?
        img_params = {
            filename: image[:filename],
            type: image[:type],
            tempfile: decode64_tempfile(image[:tempfile], image[:filename])
        }
        self.update(thumbnail:img_params)
    end
    def decode64_tempfile(file, filename)
        tempfile = URI.decode(file)
        tempfile = Base64.decode64(tempfile)
        file = Tempfile.new(filename)
        file.binmode
        file << tempfile
        file.rewind
        file
      end
end
