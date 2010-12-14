#Simple class that allows initializer for setting up the rake tasks instead of yml file
module Bakkuappu
  class Configuration

    #Configurable options
    class_attribute :s3_bucket,
                    :s3_access_key_id,
                    :s3_secret_access_key,
                    :s3_access_policy,
                    :heroku_app,
                    :heroku_user,
                    :heroku_pass,
                    :heroku_db_id

    #Set the class's default privacy policy to private
    self.s3_access_policy = 'private'
    self.heroku_db_id = "SHARED_DATABASE_URL"

    #Conventional way of setting configuration options
    def self.configure
      yield self
    end
  end
end