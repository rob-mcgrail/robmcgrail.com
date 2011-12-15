require 'nokogiri'
require 'ostruct'

class Feeds
  @@t = Time.now
  @@a = []
  
  
  def self.reddit(i=3, feed=settings.reddit_feed)
    @comments=[]
    begin
      raw_results = Nokogiri::XML(open(URI.encode(feed)))
      i.times do |num|
        o = OpenStruct.new
        o.text = raw_results.xpath('//item/description')[num].text
        o.text = o.text[0..144]
        o.text = o.text + ' ...' if o.text.length > 144
        o.url = raw_results.xpath('//item/link')[num].text
        o.date = Time.parse(raw_results.xpath('//item/dc:date')[num].text)
        o.icon = 'reddit-icon.png'
        @comments << o
      end
    end 
	  @comments
  end
  
  
  def self.lastfm(i=3, feed=settings.lastfm_feed)
    @tracks=[]
    begin
      raw_results = Nokogiri::XML(open(URI.encode(feed)))
      i.times do |num|
        o = OpenStruct.new
        o.text = raw_results.xpath('//item/title')[num].text
        o.url = raw_results.xpath('//item/link')[num].text
        o.text = 'Robomc listened to ' + "<a href='#{o.url}'>#{o.text}</a>"
        o.date = Time.parse(raw_results.xpath('//item/pubDate')[num].text)
        o.icon = 'lastfm-icon.png'
        @tracks << o
      end 
    end
	  @tracks
  end
  
  
  def self.twitter(i=3, feed=settings.twitter_feed)
    @tweets=[]
    begin
      raw_results = Nokogiri::XML(open(URI.encode(feed)))
      i.times do |num|
        o = OpenStruct.new
        o.text = raw_results.xpath('//item/title')[num].text.gsub('scaredofbabies: ','')
        o.text = o.text.gsub(/((http|https):\/\/\S+)/, "<a href=\"\\0\">\\0</a>")
        o.text = o.text.gsub(/(#\w+)/, "<a href=\"http://twitter.com/search?q=\\1\">\\1</a>")
        o.url = raw_results.xpath('//item/link')[num].text
        o.date = Time.parse(raw_results.xpath('//item/pubDate')[num].text)
        o.icon = 'twitter-icon.png'
        @tweets << o
      end
    end 
	  @tweets
  end

  def self.github(i=3, feed=settings.github_feed)
    @activities=[]
    begin
      raw_results = Nokogiri::XML(open(URI.encode(feed)))
      i.times do |num|
        o = OpenStruct.new
        o.text = raw_results.xpath('//xmlns:entry/xmlns:title')[num].text
        o.text = o.text.gsub(/((http|https):\/\/\S+)/, "<a href=\"\\0\">\\0</a>")
        o.text = o.text.gsub('robomc', '<a href="https://github.com/robomc">robomc</a>')
        o.url = raw_results.xpath('//xmlns:entry/xmlns:link/@href')[num].text
        o.date = Time.parse(raw_results.xpath('//xmlns:entry/xmlns:published')[num].text)
        o.icon = 'github-icon.png'
        @activities << o
      end
    end 
	  @activities
  end
  
  def self.feeds(i)
    a = []
    a = a + self.github( (i/2).to_i ) 
    a = a + self.twitter( (i/3).to_i )
    a = a + self.reddit( (i/6).to_i )
    a = a + self.lastfm( (i/2).to_i )
    a.sort! {|x,y| y.date <=> x.date}
  end

  def self.get(i=10)
    if (Time.now - @@t) > settings.feed_cache || @@a == []
      @@a = self.feeds(i)
      @@t = Time.now
    end
    @@a[0..i]
  end
end
