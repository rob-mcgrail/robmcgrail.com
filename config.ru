require 'rubygems'
require 'sinatra'

require 'app'

use Rack::Session::Cookie, :secret => "Ns7uwEYgHlvYp9-!.:R%*s{=#4}05J|'!*?YS[Ah7dn_SWa'.?(yMJ&.EzOskg"

use Warden::Manager do |mgmt|
  mgmt.default_strategies :password
  mgmt.failure_app = Sinatra::Application
end

run Sinatra::Application

