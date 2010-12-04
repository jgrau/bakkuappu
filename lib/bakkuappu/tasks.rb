namespace :heroku do
  desc "Heroku automated cron backup"
  task :cron => :environment do
    heroku_app = Bakkuappu::Configuration.heroku_app
    s3_access_policy = Bakkuappu::Configuration.s3_access_policy
    app_call = heroku_app.blank? ? "" : "--app #{heroku_app}"
    sh "heroku pgbackups:capture --expire #{app_call}"
    backup_url = %x( heroku pgbackups:url #{app_call} )
    msb = Bakkuappu::MultipartS3Backup.new
    msb.upload!(backup_url, s3_access_policy)
  end
end