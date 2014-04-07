require 'rubygems'

namespace :db do
  require 'dm-core'
  require 'dm-migrations'
  require './database'

  desc "Migrate the database"
  task :migrate do
    DataMapper.auto_migrate!
  end

  desc "Run a datamapper upgrade"
  task :upgrade do
    DataMapper.auto_upgrade!
  end
  
  desc "Add some test users (admin | admin)"
  task :testusers do
    User.new_user("admin","admin")
  end 
end