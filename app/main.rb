get '/?' do
  @title = title 'home'
  @content = :'content/homepage'
  @feeds = Feeds.get(12)
  haml :main
end

get '/about/?' do
  @title = title 'about'
  @content = :'content/about'
  haml :main
end

get '/academic/?' do
  @title = title 'academic'
  @content = :'content/academic'
  haml :main
end

get '/mu-1234-cafe-5678-babe' do
  '42'
end

