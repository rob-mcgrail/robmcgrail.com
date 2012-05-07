require 'rake'

task :default => [:test]

env = ENV["env"] || "development"

task :test do
  require './app'
  Bundler.require(:test)
  require 'minitest/autorun'
  Dir['./test/test_*.rb'].each {|file| require file }
end


task :server do
  system("bundle exec rackup -p 9000 -s thin")
end
