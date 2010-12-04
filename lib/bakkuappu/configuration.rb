#Simple class that allows initializer for setting up the rake tasks instead of yml file
module Bakkuappu
  class Configuration

    #Configurable options
    class_attribute :s3_bucket,
                    :s3_access_key_id,
                    :s3_secret_access_key,
                    :s3_access_policy,
                    :heroku_app

    #Set the class's default privacy policy to private
    self.s3_access_policy = 'private'

    #Conventional way of setting configuration options
    def self.configure
      yield self
    end
  end
end