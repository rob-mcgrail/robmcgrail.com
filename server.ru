require 'app'

require 'rack/perftools_profiler'
require 'rack-bundle'
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

# Compiles stylesheets into one.
# Replace this with something that compiles and compresses on startup, then leaves static.
use Rack::Bundle, :public_dir => 'public'

# Rack::Static serves files from the apps public folder.
use Rack::Static, :urls => PUBLIC_FOLDERS, :root => PUBLIC_ROOT

if DEVELOPMENT_MODE
  # Profiling of requests; foobar?profile=true&times=30
  # ?mode=methods, mode=objects
  use Rack::PerftoolsProfiler,
    :default_printer => 'text',
    :mode => :walltime
end


unless DEVELOPMENT_MODE
  # Tool for deflecting attacks / malicious bots
  use Rack::Deflect,
    :log => false,
    :request_threshold => 20,
    :interval => 2,
    :block_duration => 1800
  # :blacklist => [ip,ip,ip,ip]
  # Prevent overly quick or endless requests from clients...
  use Rack::Throttle::Interval, :min => 0.3
  use Rack::Throttle::Hourly, :max => 600
end


run Server.new

