require 'nokogiri'
require 'ostruct'

class Feeds
  def self.reddit(i=3, feed=settings.reddit_feed)
    @comments=[]
    raw_results = Nokogiri::XML(open(URI.encode(feed)))
    i.times do |num|
      o = OpenStruct.new
      o.text = raw_results.xpath('//item/description')[num].text
      o.url = raw_results.xpath('//item/link')[num].text
      o.date = raw_results.xpath('//item/dc:date')[num].text
      @comments << o
    end 
	  @comments
  end
  
  def self.lastfm(i=3, feed=settings.lastfm_feed)
    @tracks=[]
    raw_results = Nokogiri::XML(open(URI.encode(feed)))
    i.times do |num|
      o = OpenStruct.new
      o.text = raw_results.xpath('//item/title')[num].text
      o.url = raw_results.xpath('//item/link')[num].text
      o.date = raw_results.xpath('//item/pubDate')[num].text
      @tracks << o
    end 
	  @tracks
  end
  
  def self.twitter(i=3, feed=settings.twitter_feed)
    @tweets=[]
    raw_results = Nokogiri::XML(open(URI.encode(feed)))
    i.times do |num|
      o = OpenStruct.new
      o.text = raw_results.xpath('//item/title')[num].text.gsub('scaredofbabies: ','')
      o.text = o.text.gsub(/((http|https):\/\/\S+)/, "<a href=\"\\0\">\\0</a>")
      o.text = o.text.gsub(/(#\w+)/, "<a href=\"http://twitter.com/search?q=\\1\">\\1</a>")
      o.url = raw_results.xpath('//item/link')[num].text
      o.date = raw_results.xpath('//item/pubDate')[num].text
      @tweets << o
    end 
	  @tweets
  end

  def self.github(i=3, feed=settings.github_feed)
    @activities=[]
    raw_results = Nokogiri::XML(open(URI.encode(feed)))
    i.times do |num|
      o = OpenStruct.new
      o.text = raw_results.xpath('//xmlns:entry/xmlns:title')[num].text
      o.text = o.text.gsub(/((http|https):\/\/\S+)/, "<a href=\"\\0\">\\0</a>")
      o.text = o.text.gsub('robomc', '<a href="https://github.com/robomc">robomc</a>')
      o.url = raw_results.xpath('//xmlns:entry/xmlns:link')[num].text
      o.date = raw_results.xpath('//xmlns:entry/xmlns:published')[num].text
      @activities << o
    end 
	  @activities
  end
end

get '/feeds/?' do
  Feeds.twitter.first.text
end
