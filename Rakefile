require 'mongoid/tasks/database'
load 'mongoid/tasks/database.rake'

task :environment do
  ENV["RACK_ENV"] ||= "development"
  require_relative "./app"
end
