require 'helper'
require "test_configuration"

class TestBakkuappu < Test::Unit::TestCase

  #Go get the url and create a signature of the contents
  def get_remote_file_md5_hash(url, tries = 3)
    orginal_url = url
    begin
      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url.request_uri)
      return OpenSSL::Digest::MD5.new(request.body).hexdigest
    rescue
      if tries > 0
        get_remote_file_md5_hash(orginal_url, tries - 1)
      else
        raise
      end
    end 
  end

  
  context "Test S3 configuration" do
    setup do
      @config = Bakkuappu::Configuration
    end

    should "upload file successfully and be equal to original" do
  
      backup_url = %x( heroku pgbackups:url --app #{@config.heroku_app} )
      
      original_hash = get_remote_file_md5_hash(backup_url)
      p original_hash

      #upload to s3
      msb = Bakkuappu::MultipartS3Backup.new
      response = msb.upload!(backup_url, @config.s3_access_policy)

      bucket_name = response.body["Bucket"]
      object_name = response.body["Key"]

      storage = Fog::Storage.new(
        :provider => 'AWS',
        :aws_access_key_id => @config.s3_access_key_id,
        :aws_secret_access_key => @config.s3_secret_access_key)

      #Expires in 5 hours expressed in seconds
      expires = (Time.now + 60*60*5).to_i

      #Get the newly uploaded object and get its hash digest
      new_url =storage.get_object_url(bucket_name, object_name,  expires)
      new_hash = get_remote_file_md5_hash(new_url)
      p new_hash

      assert_equal original_hash, new_hash, "Uploaded file was not the same as original"
    end
  end
end
