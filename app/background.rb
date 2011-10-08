get '/background/?' do
  authorize!
  @title = title 'background'
  haml :'background/change'
end

post '/background/?' do
  authorize!
  @title = title 'background'
  if params[:background] =~ URI::regexp
    flash[:success] = 'Background changed'
    settings.background = params[:background]
    redirect '/'
  else
    flash[:error] = 'Something was wrong with that'
    redirect 'background'
  end
end

get '/background/reset/?' do
  @title = title 'background reset'
  settings.background = 'http://catlovers.todayblogpost.com/wp-content/uploads/2011/01/wpid-ScottishFoldHistory21.jpg'
  flash[:error] = 'Background reset'
  redirect '/'
end
