get '/?' do
  title
  @feeds = Feeds.get
  haml :main
end


post '/change/?' do
  title
  settings.background = params[:url]
  200
end
