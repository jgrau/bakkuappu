require 'bakkuappu'
require 'rails'

module Bakkuappu
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'bakkuappu/tasks.rb'
    end
  end
end