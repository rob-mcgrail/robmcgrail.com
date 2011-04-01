class Main < AbstractController


  R.add '/', 'Main#home', 'home'

  def home
    @title = 'home'
    @patter = 'Welcome to <strong>robmcgrail.com</strong>'

    render 'main/home', :layout => 'layouts/main'
  end


  R.add '/about-this-site', 'Main#about_this_site', 'about_this_site'

  def about_this_site
    @title = 'about this site'
    @patter = 'How do such things come to be?'

    render 'main/about_this_site', :layout => 'layouts/main'
  end

end

