class Background
  include DataMapper::Resource
  property :id,         Serial # primary serial key
  property :url,        String,  :required => true,  :length => 100
  
  def self.random
    x = Background.count
    @background = Background.get(1+rand(x))
  end
end

get '/background/?' do
  authorize!
  @title = title 'background'
  haml :'background/change'
end


get '/background/random/?' do
  @title = title 'randomise'
  @background = Background.new(:url => Background.random.url)
  @background.save
  flash[:success] = 'Random Background Instantiation Performed'
  redirect '/'
end


post '/background/?' do
  authorize!
  @title = title 'background'
  
  if valid_image_link(params[:background])
    @background = Background.new(:url => params[:background])
  else
    flash[:error] = 'Invalid url'
    redirect 'background'
  end
  
  if @background.save
    flash[:success] = 'Background changed'
    redirect '/'
  else
    flash[:error] = 'Something was wrong with that'
    redirect 'background'
  end
end


before do
  begin
    @background_url = Background.last.url
  rescue
    @background = Background.new(:url => settings.background)
    @background.save
    retry
  end
end
