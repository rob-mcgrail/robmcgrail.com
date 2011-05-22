class Adminful < AbstractController
  R.add '/admin', 'Adminful#dashboard', :name => 'admin'
  # Dashboard for admin actions
  def dashboard
    @title = 'Admin'
    render 'admin/dashboard', :layout => 'layouts/main'
  end


  R.add '/admin/clear_views', 'Adminful#clear_hardcache', :type => 'post'
  # Clears the view/hard cache
  def clear_hardcache
    HardCache.clear
    redirect_to 'Adminful#dashboard', :flash => 'Cleared view cache'
  end


  R.add '/admin/clear_templates', 'Adminful#clear_all_caches', :type => 'post'
  # Clears the template chache
  def clear_all_caches
    TemplateCache.clear
    HardCache.clear
    redirect_to 'Adminful#dashboard', :flash => 'Cleared template and view cache'
  end


  R.add '/admin/destructively_update_db', 'Adminful#destructively_update_db', :type => 'post'
  # Wipes and updates the database
  # Only available in development mode for now
  def destructively_update_db
    if SETTINGS[:development_mode]
      DataMapper.auto_migrate!
      redirect_to 'Adminful#dashboard', :flash => 'Destructively updated database'
    else
      redirect_to 'Adminful#dashboard', :flash => 'Failed to rebuild database, because that\'s insane'
    end
  end


  R.add '/admin/update_db', 'Adminful#update_db', :type => 'post'
  # Only available in development mode for now
  def update_db
    DataMapper.auto_upgrade!
    redirect_to 'Adminful#dashboard', :flash => 'Updated database'
  end
end

