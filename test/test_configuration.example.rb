#
# If you want to test this system yourself outside of rails you will need to
# update these settings
#
require 'helper'
Bakkuappu::Configuration.configure do |config|
  config.s3_access_key_id = # s3_access_key_id
  config.s3_secret_access_key =  #s3_secret_access_key
  config.s3_bucket = #s3_bucket
  config.heroku_app = #heroku_app
  config.heroku_user = #user_name
  config.heroku_pass = #password

  #See http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadInitiate.html
  #values include : private | public-read | public-read-write | authenticated-read | bucket-owner-read | bucket-owner-full-control
  config.s3_access_policy = 'private'

end