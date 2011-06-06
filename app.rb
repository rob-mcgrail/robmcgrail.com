require 'rubygems'
require 'sinatra'
require 'sinatra/url_for'
require 'sinatra/static_assets'
require 'sinatra/flash'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-tags'
require 'warden'
require 'bcrypt'
require 'RedCloth'
require 'haml'
require 'coderay'
require 'haml-coderay'
require 'redclothcoderay'

require 'settings'

Dir['helpers/*.rb'].each {|file| require file }
Dir['app/*.rb'].each     {|file| require file }

DataMapper.finalize

