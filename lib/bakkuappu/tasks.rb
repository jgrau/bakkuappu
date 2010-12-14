namespace :heroku do
  desc "Heroku automated cron backup"
  task :cron => :environment do
    config = Bakkuappu::Configuration
    heroku = Heroku::Client.new(config.heroku_user, config.heroku_pass)
    @args = config.heroku_app.blank? ? [] : ["--app", config.heroku_app]
    Heroku::Command.run_internal("pgbackups:capture", @args + ["--expire"], heroku)
    pg_backup = Heroku::Command::Pgbackups.new(@args, heroku)
    backup_url = pg_backup.pgbackup_client.get_latest_backup['public_url']
    backup_url.strip unless backup_url.blank?
   
    msb = Bakkuappu::MultipartS3Backup.new
    msb.upload!(backup_url, config.s3_access_policy)
  end
end