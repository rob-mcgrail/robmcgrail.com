require 'app'

require 'rack/perftools_profiler'
require 'rack/throttle'
require 'rack/contrib'
# The rack interface. Runs with:
# rackup -s server -p port server.ru
#
# Passes rack requests off to the Dispatcher, which responds with
# the usual 3 part array.
# see:
# http://rack.rubyforge.org/doc/
# http://m.onkey.org/ruby-on-rack-1-hello-rack
# http://rack.rubyforge.org/doc/files/SPEC.html
class Server
  def call(env)
    Dispatcher << Rack::Request.new(env)
  end
end

# Rack::Static can server files from the apps public folder.
# You're best off doing this via a reverse proxy, ala nginx.
# use Rack::Static, :urls => PUBLIC_FOLDERS, :root => PUBLIC_ROOT

if SETTINGS[:development_mode]
  # Profiling of requests; foobar?profile=true&times=30
  # ?mode=methods, mode=objects
  use Rack::PerftoolsProfiler,
    :default_printer => 'text',
    :mode => :walltime
end


unless SETTINGS[:development_mode]
  # Tool for deflecting attacks / malicious bots
  use Rack::Deflect,
    :log => false,
    :request_threshold => 20,
    :interval => 2,
    :block_duration => 1800
  # :blacklist => [ip,ip,ip,ip]
  # Prevent endless requests from clients...
  use Rack::Throttle::Hourly, :max => 600
end


run Server.new

