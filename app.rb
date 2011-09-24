require 'rubygems'

# Sinatra
require 'sinatra'
require 'sinatra/url_for'
require 'sinatra/static_assets'
require 'sinatra/flash'

# Models
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-tags'

# Authentication
require 'warden'
require 'bcrypt'

# Templates
require 'RedCloth'
require 'haml'
require 'coderay'
require 'haml-coderay'
require 'redclothcoderay'

# XML/Solr
require 'nokogiri'
require 'rest_client'

require 'settings'

Dir['helpers/*.rb'].each {|file| require file }
Dir['app/*.rb'].each     {|file| require file }

DataMapper.finalize

