class Adminful < AbstractController
  R.add '/fresh_templates', 'Adminful#refresh_templates', 'refresh_templates'
  # Clears the template chache
  def refresh_templates
    @title = 'Cleared template caches'
    @error = 'Cleared template caches'
    TemplateCache.clear
    render 'errors/generic'
  end

  R.add '/render_again', 'Adminful#clear_all_caches', 'clear_caches'
  # Clears the template chache
  def refresh_templates
    @title = 'Cleared all caches'
    @error = 'Cleared all caches'
    TemplateCache.clear
    HardCache.clear
    render 'errors/generic'
  end
end

