get '/?' do
  @title = title 'home'
  @content = :'content/homepage'
  haml :main
end

get '/about/?' do
  @title = title 'about'
  @content = :'content/about'
  haml :main
end

