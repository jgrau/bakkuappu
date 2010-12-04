require 'active_support/core_ext/numeric/bytes'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/blank'
require 'net/http'
require 'uri'
require 'fog'
require 'bakkuappu/multipart_s3_backup.rb'
require 'bakkuappu/configuration.rb'
require 'bakkuappu/railtie.rb' if defined?(Rails) && Rails::VERSION::MAJOR == 3

