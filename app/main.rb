get '/?' do
  title
  @feeds = Feeds.get
  haml :main
end
