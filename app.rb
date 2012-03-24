# Sinatra
require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/flash'

# Templates/markup
require 'haml'
require 'RedCloth'
require 'bluecloth'


require './settings'

Dir['./modules/*.rb'].each {|file| require file }
Dir['./app/*.rb'].each {|file| require file }
