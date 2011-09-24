require 'rubygems'
require 'sinatra'

require 'app'

#use Rack::Session::Cookie, :key => '_robo', :secret => "Ns7uwEYgHlvYp9-!.:R%*s{=#4}05J|'!*?YS[Ah7dn_SWa'.?(yMJ&.EzOskg"

# Serve assets locally in development mode; served via reverse proxy in production mode
if settings.development?
  use Rack::Static, :urls => ["/stylesheets", "/js", "/images", "robots.txt"], :root => "public"
end

use Warden::Manager do |mgmt|
  mgmt.default_strategies :password
  mgmt.failure_app = Sinatra::Application
end

run Sinatra::Application

