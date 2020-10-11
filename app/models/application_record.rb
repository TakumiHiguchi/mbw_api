class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def s3_presigner(props)
    if Rails.env.development?
      return nil
    elsif Rails.env.production?
      s3 = Aws::S3::Resource.new(
        region: ENV['S3_REGION'],
        credentials: Aws::Credentials.new(
            ENV['S3_ACCESS_KEY'],
            ENV['S3_SECRET_KEY']
        )
      )
      signer = Aws::S3::Presigner.new(client: s3.client)
      presigned_url = signer.presigned_url(:get_object,bucket: ENV['S3_BUCKET'], key: props[:path], expires_in: 60)
      return presigned_url
    else
      return nil
    end
  end
end
