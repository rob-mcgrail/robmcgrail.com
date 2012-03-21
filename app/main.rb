get '/?' do
  title
  @feeds = Feeds.get
  haml :main
end


post '/change/?' do
  settings.background = params[:url]
  200
end
