class Adminful < AbstractController
  R.add '/fresh_templates', 'Adminful#refresh_templates', :name => 'refresh_templates'
  # Clears the template chache
  def refresh_templates
    @title = 'Cleared template caches'
    @error = 'Cleared template caches'
    TemplateCache.clear
    render 'errors/generic'
  end


  R.add '/render_again', 'Adminful#clear_all_caches', :name => 'clear_caches'
  # Clears the template chache
  def clear_all_caches
    @title = 'Cleared all caches'
    @error = 'Cleared all caches'
    TemplateCache.clear
    HardCache.clear
    render 'errors/generic'
  end


  R.add '/destructively_update_db', 'Adminful#destructively_update_db'
  # Wipes and updates the database
  # Only available in development mode for now
  def destructively_update_db
    @title = 'Destructively update database'
    if SETTINGS[:development_mode]
      DataMapper.auto_migrate!
      @error = 'Updated database'
    else
      @error = 'Can\'t destructively upate database on a production install'
    end
    render 'errors/generic'
  end


  R.add '/update_db', 'Adminful#update_db'
  # Only available in development mode for now
  def update_db
    @title = 'Update database'
    @error = 'Updated database'
    DataMapper.auto_upgrade!
    render 'errors/generic'
  end
end

