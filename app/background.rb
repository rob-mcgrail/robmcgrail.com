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
  haml :'background/change'
end
