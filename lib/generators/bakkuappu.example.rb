Bakkuappu::Configuration.configure do |config|
  config.s3_access_key_id = #your_s3_access_key_id
  config.s3_secret_access_key = #your_s3_secret_access_key
  config.s3_bucket =  #your_s3_bucket
  config.heroku_app = #your_heroku_app

  #See http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadInitiate.html
  #values include : private | public-read | public-read-write | authenticated-read | bucket-owner-read | bucket-owner-full-control
  config.s3_access_policy = 'private'

end