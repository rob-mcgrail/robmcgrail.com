class Main < AbstractController

  R.add 'test/:cat/:slug', 'Main#test', 'testing'

  def test
    @title = @p.cat
    @error = @p.slug

    render 'errors/generic'
  end


  R.add '/', 'Main#home', 'home'

  def home
    @title = 'home'

    render 'main/home', :layout => 'layouts/main', :cachable => true
  end


  R.add '/about-this-site', 'Main#about_this_site', 'about_this_site'

  def about_this_site
    @title = 'about this site'

    render 'main/about_this_site', :layout => 'layouts/main', :cachable => true
  end

end

