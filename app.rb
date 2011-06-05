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
require 'RedCloth'
require 'haml'
require 'coderay'
require 'haml-coderay'
require 'redclothcoderay'

require 'settings'


class String
  def parameterize
    self.gsub(/[^a-z0-9\-_!?]+/i, '-').downcase
  end
end

Dir['app/*.rb'].each {|file| require file }

DataMapper.finalize

