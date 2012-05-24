require 'nokogiri'
require 'ostruct'
require 'uri'
require 'open-uri'

class Feeds
  @@t = Time.now
  @@a = []


  def self.get
    if (Time.now - @@t) > settings.feed_cache || @@a == []
      @@a = self.feeds
      @@t = Time.now
    end
    @@a
  end


  def self.feeds
    a = []
    reddit = self.reddit(25)
    lastfm = self.lastfm(100)
    twitter = self.twitter(30)
    github = self.github(30)
    a = a + reddit if reddit
    a = a + lastfm if lastfm
    a = a + twitter if twitter
    a = a + github if github
    a.sort! {|x,y| y.date <=> x.date}
  end


  def self.reddit(i=3, feed=settings.reddit_feed)
    xpaths = {
      :text => '//item/description',
      :date => '//item/dc:date',
      :url => '//item/link'
    }
    data = self.get_feed(feed)
    if data
      items = self.parse(i, data, xpaths)
      items.each do |item|
        item.icon = 'reddit-icon.png'
        item.date = Time.parse(item.date)
        item.url = item.url + '?context=3'
        item.text = item.text[0..100]
        item.text = item.text + " <a href='#{item.url}' class='plain'>...</a>" if item.text.length > 100
        item.text = BlueCloth.new(item.text).to_html
        item.text.gsub!('href="/', 'href="http://reddit.com/')
      end
    end
  end


  def self.lastfm(i=3, feed=settings.lastfm_feed)
    xpaths = {
      :text => '//item/title',
      :date => '//item/pubDate',
      :url => '//item/link'
    }
    data = self.get_feed(feed)
    if data
      items = self.parse(i, data, xpaths)
      items.each do |item|
        item.icon = 'lastfm-icon.png'
        item.date = Time.parse(item.date)
        item.text = "<p><a href='http://www.last.fm/user/robomc'>robomc</a> listened to <a href='#{item.url}'>#{item.text}</a></p>"
      end
    end
  end


  def self.twitter(i=3, feed=settings.twitter_feed)
    xpaths = {
      :text => '//item/description',
      :date => '//item/pubDate',
      :url => '//item/link'
    }
    data = self.get_feed(feed)
    if data
      items = self.parse(i, data, xpaths)
      items.each do |item|
        item.icon = 'twitter-icon.png'
        item.date = Time.parse(item.date)
        item.text.gsub!('scaredofbabies: ','')
        item.text.gsub!(/((http|https):\/\/\S+)/, "<a href=\"\\0\">\\0</a>")
        item.text.gsub!(/(#\w+)/, "<a href=\"http://twitter.com/search?q=\\1\">\\1</a>")
        item.text.gsub!(/@(\w+)/, "<a href=\"http://twitter.com/\\1\">@\\1</a>")
        item.text = '<p>' + item.text + '</p>'
      end
    end
  end


  def self.github(i=3, feed=settings.github_feed)
    xpaths = {
      :text => '//xmlns:entry/xmlns:title',
      :date => '//xmlns:entry/xmlns:published',
      :url => '//xmlns:entry/xmlns:link/@href'
    }
    data = self.get_feed(feed)
    if data
      items = self.parse(i, data, xpaths)
      items.each do |item|
        item.icon = 'github-icon.png'
        item.date = Time.parse(item.date)
#        item.text.gsub!(/((http|https):\/\/\S+)/, "<a href=\"\\0\">\\0</a>")
        item.text.gsub!(/ (\S+\/\S+)/, " <a href='https://github.com/\\1'>\\1</a> ")
        item.text.gsub!(' pushed ', " <a href='#{item.url}'>pushed</a> ")
        item.text.gsub!(/^robomc/, '<a href="https://github.com/robomc">robomc</a> ')
        item.text.gsub!(/gist: (\d+)/, "<a href='https://gist.github.com/\\1'>\\0</a>")
        item.text = '<p>' + item.text + '</p>'
      end
    end
  end


  def self.parse(i, data, xpaths)
    items = []
    if data
      i.times do |num|
        o = OpenStruct.new
        if data.xpath(xpaths.values.first)[num]
          xpaths.each do |k,v|
            o.send("#{k}=", data.xpath(v)[num].text)
          end
          items << o
        end
      end
    else
      nil
    end
    items
  end


  def self.get_feed(feed)
    begin
      raw = Nokogiri::XML(open(URI.encode(feed)))
    rescue
      nil
    end
    raw
  end
end
