class InitializerGenerator < Rails::Generators::Base
  def create_initializer_file
    f= File.open("../heroku_streaming_s3_backups.example")
    create_file "config/initializers/heroku_streaming_s3_backups.rb", f.readlines.join("\n")
  end
end