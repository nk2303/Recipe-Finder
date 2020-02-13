require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end


desc 'gets the ingredient'
task :ingredient do
  Ingredient.all.each{|item| puts item}
end