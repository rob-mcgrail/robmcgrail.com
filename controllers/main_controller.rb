class Main < AbstractController


  R.add '/', 'Main#home', 'home'

  def home
    @title = 'home'

    render 'main/home', :layout => 'layouts/main'
  end


  R.add '/about-this-site', 'Main#about_this_site', 'about_this_site'

  def about_this_site
    @title = 'about this site'

    render 'main/about_this_site', :layout => 'layouts/main'
  end

end

