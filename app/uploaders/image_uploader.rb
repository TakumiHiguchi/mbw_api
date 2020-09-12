class ImageUploader < CarrierWave::Uploader::Base
  
   storage :fog
  
   # S3のディレクトリ名
   def store_dir
     "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
   end
  
   # 許可する画像の拡張子
   def extension_whitelist
      %w(jpg jpeg png)
   end
  
   # 保存するファイルの命名規則
   def filename
      "#{secure_token}.#{file.extension}" if original_filename.present?
   end
  
   protected
   # 一意となるトークンを作成
   def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
   end
end
