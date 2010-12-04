module Bakkuappu
  class MultipartS3Backup

    def initialize(chunk_size = 5.megabytes)
      raise ArgumentError.new("chunksize must be greater than 5Mb") unless chunk_size >= 5.megabytes

      #Upload part tracking
      @chunk_size = chunk_size
      @chunk_store = ""
      @part_number = 1
      @parts = []

      #S3 config
      @s3_access_key_id = Bakkuappu::Configuration.s3_access_key_id
      @s3_secret_access_key = Bakkuappu::Configuration.s3_secret_access_key
      @s3_bucket = Bakkuappu::Configuration.s3_bucket
      @heroku_app = Bakkuappu::Configuration.heroku_app

      if @s3_access_key_id.blank? || @s3_secret_access_key.blank? || @s3_bucket.blank? || @heroku_app.blank?
        raise ArgumentError.new("Missing one of the required configuration options. Check your s3 keys and bucket in config")
      end

      @storage = Fog::Storage.new(
        :provider => 'AWS',
        :aws_access_key_id => @s3_access_key_id,
        :aws_secret_access_key => @s3_secret_access_key) 
    end

    #Simply pass the url you want to push to S3
    def upload!(backup_url, s3_access_policy ,object_prefix='')

      puts "Begining multipart upload to S3"
      #Begin the upload and get upload id
      object_name = "#{object_prefix}#{@heroku_app}-#{Time.now.to_s}"
      options = {'x-amz-acl' => s3_access_policy}
      upload_id = initiate_multipart_upload(object_name, options)
      
      #Do the uploading
      url = URI.parse(backup_url)
      Net::HTTP.start(url.host, url.port) do |http|

        #Upload parts until finished
        http.get(url.request_uri) do |str|
          upload_part(object_name, upload_id) if(@chunk_store.size > @chunk_size)
          @chunk_store += str
        end

        #If we had a bit left send that off
        if @chunk_store.size > 0
          upload_part(object_name, upload_id)
        end
      end

      #Finish the response
      response = @storage.complete_multipart_upload(@s3_bucket, object_name, upload_id, @parts)
      print_final_response(response)
      
      return response
    end

    private

    def initiate_multipart_upload(object_name, options)
      response = @storage.initiate_multipart_upload(@s3_bucket, object_name, options)
      return response.body["UploadId"]
    end

    def upload_part(object_name, upload_id)
      puts "Upload part #{@part_number}..."
      response = @storage.upload_part(@s3_bucket, object_name, upload_id, @part_number, @chunk_store)
      @parts << response.headers["ETag"]
      @chunk_store = ""
      @part_number += 1
    end

    def print_final_response(response)
      bucket_name = response.body["Bucket"]
      etag = response.body["ETag"]
      key = response.body["Key"]
      location = response.body["Location"]

      puts "Upload complete on bucket: #{bucket_name} with Etag: #{etag} and Key #{key} to #{location}"
    end
  end
end