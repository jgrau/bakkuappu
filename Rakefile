require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bakkuappu"
  gem.homepage = "http://github.com/mrich54907/bakkuappu"
  gem.license = "MIT"
  gem.summary = %Q{Safe reliable streaming S3 backups of your heroku db}
  gem.description = %Q{All of the heroku automated backup solutions for s3 either are outdated or
                      sadly very unreliable. This gem makes NO use of the tmp folder on heroku as
                      doing so opens up the possibility of corrupted backups should heroku decide
                      to clear it when you are backing up. It also scales to larger databases as
                      solutions using heroku's tmp folders don't have any clue how large that directory
                      is or when backups will fail because of size limitations.

                      Instead of downloading the whole backup in one big download and storing to tmp
                      we instead use Net:Http and its lower level interfaces to get data and send data
                      in ordered chunks using Amazon's multipart upload rest api.}
  
  gem.email = "trcarden@gmail.com"
  gem.authors = ["Timothy Cardenas"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_runtime_dependency 'fog', '> 0.3.25'
  gem.add_runtime_dependency "activesupport", ">= 3.0.0"
  gem.add_development_dependency 'heroku'

end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bakkuappu #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
